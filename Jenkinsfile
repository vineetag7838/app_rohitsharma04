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
	cluster_name = 'kubernetes-cluster-rohitsharma04'
	location = 'us-central1-c'
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
			   bat "docker build -t i-rohit2522-develop:${BUILD_NUMBER} --no-cache -f Dockerfile ."   
		  }
	}
	stage('Container') {
		parallel{
			stage('Precontainer Check') {
				steps {
				   bat "docker rm -f c-rohit2522-develop || exit 0 && docker rm c-rohit2522-develop || exit 0"
					
				}
			}
			stage('Push to Dockerhub Repo') {
			  steps{
					 bat "docker tag i-rohit2522-develop:${BUILD_NUMBER} ${registry}:${BUILD_NUMBER}"
					 bat "docker tag i-rohit2522-develop:${BUILD_NUMBER} ${registry}:latest"
					 withDockerRegistry([credentialsId: 'Test_Docker', url:""]){
						bat "docker push ${registry}:develop-${BUILD_NUMBER}"
						bat "docker push ${registry}:develop-latest"
					}
			  }
			}
		}
	}
	stage('Docker deployment') 
	{            
		 steps{
			script {
			  bat "docker run --name c-rohit2522-develop -d -p 7300:8080 ${registry}:${BUILD_NUMBER}" 
			}
		}
	}
	stage('Deploy to GK8E') {
		steps {
			bat "kubectl apply -f deployment.yaml"
		}
	}
	
  }
}
