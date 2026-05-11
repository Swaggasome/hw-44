# Сервисный аккаунт для управления кластером
resource "yandex_iam_service_account" "k8s_cluster" {
  name        = "${var.cluster_name}-cluster-sa"
  description = "Service Account for managing K8S cluster resources"
}

# Назначение роли editor на каталог для управления ресурсами
resource "yandex_resourcemanager_folder_iam_member" "k8s_cluster_editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_cluster.id}"
}

# Сервисный аккаунт для узлов кластера
resource "yandex_iam_service_account" "k8s_nodes" {
  name        = "${var.cluster_name}-nodes-sa"
  description = "Service Account for K8S worker nodes"
}

# Назначение роли container-registry.images.puller для доступа к Container Registry
resource "yandex_resourcemanager_folder_iam_member" "k8s_nodes_puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_nodes.id}"
}

# Назначение роли logging.writer для отправки логов
resource "yandex_resourcemanager_folder_iam_member" "k8s_nodes_logs" {
  folder_id = var.folder_id
  role      = "logging.writer"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_nodes.id}"
}
