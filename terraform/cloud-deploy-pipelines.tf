# copied from https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/clouddeploy_delivery_pipeline

resource "google_clouddeploy_delivery_pipeline" "primary" {
  location = "us-west1"
  name     = "tf-pipeline-pp01"

  annotations = {
    my_first_annotation = "example-annotation-1"
    my_second_annotation = "example-annotation-2"
  }

  description = "[Created with Terraform] basic description"

  labels = {
    my_first_label = "example-label-1"
    my_second_label = "example-label-2"
  }

#  project = "my-project-name"
  project = "$project_id"

  serial_pipeline {
    stages {
      profiles  = ["example-profile-one", "example-profile-two"]
      target_id = "example-target-one"
    }

    stages {
      profiles  = []
      target_id = "example-target-two"
    }
  }
}
