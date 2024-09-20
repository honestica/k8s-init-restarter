from kubernetes import client, config


def main():
    config.load_incluster_config()

    kubeclient = client.CoreV1Api()

    namespaces = kubeclient.list_namespace()

    for ns in namespaces.items:
        namespace = ns.metadata.name
        print(f"Namespace: {namespace}")

        pods = kubeclient.list_namespaced_pod(namespace)

        pods_with_failed_init_containers = []

        for pod in pods.items:
            pod_name = pod.metadata.name
            init_containers = pod.status.init_container_statuses

            if init_containers:
                for init_container in init_containers:
                    state = init_container.state
                    if state.waiting and state.waiting.reason == "CreateContainerError":
                        pods_with_failed_init_containers.append(pod_name)
                        break

        if pods_with_failed_init_containers:
            print("  Pods with init containers in 'CreateContainerError' state:")
            for pod_name in pods_with_failed_init_containers:
                print(f"    - {pod_name}")

                try:
                    kubeclient.delete_namespaced_pod(pod_name, namespace)
                    print(f"    Deleted pod: {pod_name}")
                except client.exceptions.ApiException as e:
                    print(f"    Failed to delete pod: {pod_name}. Reason: {e.reason}")
        else:
            print(
                "  No pods with init containers in 'CreateContainerError' state found."
            )


if __name__ == "__main__":
    main()
