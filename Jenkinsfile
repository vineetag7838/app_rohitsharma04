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
	project_id = 'nagp-assignment-project'
	cluster_name = 'cluster-master'
	location = 'us-central1-c'
	credentialsId = 'Test_GKE'

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
	 stage ('Build')
	 {
		steps
		{
		   echo "build in master branch - 2"
		   bat "mvn clean install -Dhttps.protocols=TLSv1.2"
		}
	 }
	 stage ('Unit Testing')
	 {
		steps
		{
		   bat "mvn test"
		}
	 }
	 stage ('Sonar Analysis')
	 {
		environment 
		{
		   scannerHome = tool name: 'SonarQubeScanner'
		}
		steps
		{
		   withSonarQubeEnv("Test_Sonar")
		   {
			  bat "mvn sonar:sonar -Dhttps.protocols=TLSv1.2"
		   }
		}

	 }
	stage('Docker image') 
	{
		  steps
		  {
			   bat "docker build -t i-rohit2522-master:${BUILD_NUMBER} --no-cache -f Dockerfile ."   
		  }
	}
	stage('Container') {
		parallel{
			stage('Precontainer Check') {
				steps {
				   bat "docker rm -f c-rohit2522-master || exit 0 && docker rm c-rohit2522-master || exit 0"
					
				}
			}
			stage('Push to Dockerhub Repo') {
			  steps{
					 bat "docker tag i-rohit2522-master:${BUILD_NUMBER} ${registry}:master-${BUILD_NUMBER}"
					 bat "docker tag i-rohit2522-master:${BUILD_NUMBER} ${registry}:master-latest"
					 withDockerRegistry([credentialsId: 'Test_Docker', url:""]){
						bat "docker push ${registry}:master-${BUILD_NUMBER}"
				 		bat "docker push ${registry}:master-latest"				
							
					}
			  }
			}
		}
	}
	stage('Docker deployment') 
	{            
		 steps{
			script {
			  bat "docker run --name c-rohit2522-master -d -p 7200:8080 ${registry}:master-latest" 
			}
		}
	}
	stage('Deploy to GK8E') {
		steps{   
              step([$class: 'KubernetesEngineBuilder', projectId: env.project_id, clusterName: env.cluster_name, location: env.location, manifestPattern: 'deployment.yaml', credentialsId: env.credentials_id, verifyDeployment: true])
        }
	}
	
  }
}
