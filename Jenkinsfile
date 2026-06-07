def tagAndPush(String localImage, String repo, String registry, String credential){
    docker.withRegistry(registry, credential){
        sh "docker tag ${localImage} ${repo}"
        sh "docker tag ${localImage} ${repo}:${BUILD_NUMBER}"
        sh "docker tag ${localImage} ${repo}:${APP_SEMANTIC_VERSION}"
        sh "docker push ${repo}"
        sh "docker push ${repo}:${BUILD_NUMBER}"
        sh "docker push ${repo}:${APP_SEMANTIC_VERSION}"
    }
}

pipeline {
    agent none
    environment{
        IMAGE_NAME = 'tarea-final'
        DH_REPO = 'dromerocl/tara-final'
        GH_REPO = 'ghcr.io/dromerop/tara-final'
        K8S_NAMESPACE = 'ns-daniel-romero'
    }
    stages{
        stage('CI - de nuestra aplicacion de contenedores'){
            agent {
                kubernetes {
                    yamlFile 'agent.yaml'
                }
            }
            stages{
                stage('CI - Instalacion de dependencias'){
                    steps{
                        sh '''
                        pnpm install
                        '''
                    }
                }
                stage('CI - Ejecucion de build'){
                    steps{
                        sh '''
                        pnpm build
                        '''
                    }
                }

            }
        }
//        stage('CD - Empaquetado y distribucion'){
//            agent {
//                label 'docker'
//            }
//            steps{
//                sh '''
//                    docker build -t ${IMAGE_NAME} .
//                '''
//                script{
//                    tagAndPush(env.IMAGE_NAME, env.DH_REPO, 'https://index.docker.io/v1/','dh-credencial' )
//                    tagAndPush(env.IMAGE_NAME, env.GH_REPO, 'https://ghcr.io','gh-credencial' )
//                }
//            }
//        }
//        stage('CD - Despliegue en K8'){
//            agent {
//                docker {
//                    image 'alpine/k8s:1.34.1'
//                }
//            }
//            steps {
//                script {
//                    withKubeConfig([credentialsId: 'kubernetes-config']){
//                        sh '''
//                            kubectl -n ${K8S_NAMESPACE} set image deployment/${IMAGE_NAME} ${IMAGE_NAME}=${DH_REPO}:${APP_SEMANTIC_VERSION}
//                            kubectl -n ${K8S_NAMESPACE} rollout status deployment/${IMAGE_NAME}
//                        '''
//                    }
//                }
//            }
//        }
    }
}