def getGitBranchName() {
	return scm.branches[0].name
}
pipeline
{   
  agent any 
  environment 
  {
	registry = "rohit2522/nagp-jenkins-assignment"
	branch = getGitBranchName()
	project_id = 'nagp-assignment-project-322106'
	cluster_name = 'cluster-master'
	location = 'us-central1-c'
	credentials_id = 'Test_GKE'

  }
  tools
  {
	 maven 'Maven3'
  }     
  options
  {
	  skipDefaultCheckout()
	  disableConcurrentBuilds()
  }
  stages
  {
	 stage ('Checkout')
	 {
		steps
		{
		   echo "build in master branch - 1"
		   checkout scm
		   
		}
	 }
	 
	stage('Deploy to GK8E') {
		steps{   
              bat "kubectl apply -f deployment.yaml"
        }
	}
	
  }
}
