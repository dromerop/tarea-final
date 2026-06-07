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
        IMAGE_NAME = 'curso-contenedores'
        DH_REPO = 'carlosmarind/curso-contenedores'
        GH_REPO = 'ghcr.io/carlosmarind/curso-contenedores'
        K8S_NAMESPACE = 'curso-contenedores'
    }
    stages{
        stage('CI - de nuestra aplicacion de contenedores'){
            agent{
                docker {
                    image 'ghcr.io/pnpm/pnpm:latest'
                    label 'docker'
                }
            }
            stages{
                stage('CI - Configuracion de pnpm y node'){
                    steps{
                        sh '''
                        pnpm runtime set node 24 -g
                        pnpm --version
                        '''
                    }
                }
                stage('CI - Instalacion de dependencias'){
                    steps{
                        sh '''
                        pnpm install
                        '''
                    }
                }
                stage('CI - Revision de linter'){
                    steps{
                        sh '''
                        pnpm lint
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
                stage('CI - Obtener semver'){
                    steps{
                        script {
                            env.APP_SEMANTIC_VERSION = sh(
                                script: '''
                                    node -p "require('./package.json').version"
                                ''',
                                returnStdout:true
                            ).trim()
                            echo "Version semantica detectada : ${env.APP_SEMANTIC_VERSION}"
                        }
                    }
                }
            }
        }
        stage('CD - Empaquetado y distribucion'){
            agent { label 'docker'}
            steps{
                sh '''
                    docker build -t ${IMAGE_NAME} .
                '''
                script{
                    tagAndPush(env.IMAGE_NAME, env.DH_REPO, 'https://index.docker.io/v1/','dh-credencial' )
                    tagAndPush(env.IMAGE_NAME, env.GH_REPO, 'https://ghcr.io','gh-credencial' )
                    //docker.withRegistry('https://index.docker.io/v1/','dh-credencial'){
                    //    sh 'docker push ${DH_REPO}:latest'
                    //    sh 'docker push ${DH_REPO}:${BUILD_NUMBER}'
                    //    sh 'docker push ${DH_REPO}:${APP_SEMANTIC_VERSION}'
                    //
                    //}
                    //docker.withRegistry('https://ghcr.io','gh-credencial'){
                    //    sh 'docker push ${GH_REPO}:latest'
                    //    sh 'docker push ${GH_REPO}:${BUILD_NUMBER}'
                    //    sh 'docker push ${GH_REPO}:${APP_SEMANTIC_VERSION}'
                    //}
                }
            }
        }
        stage('CD - Despliegue en K8'){
            agent {
                docker {
                    image 'alpine/k8s:1.34.1'
                }
            }
            steps {
                script {
                    withKubeConfig([credentialsId: 'kubernetes-config']){
                        sh '''
                            kubectl -n ${K8S_NAMESPACE} set image deployment/${IMAGE_NAME} ${IMAGE_NAME}=${DH_REPO}:${APP_SEMANTIC_VERSION}
                            kubectl -n ${K8S_NAMESPACE} rollout status deployment/${IMAGE_NAME}
                        '''
                    }
                }
            }
        }
    }
}