pipeline {
    agent {
        kubernetes {
            defaultContainer 'pnpm'
            yamlFile 'agent.yaml'
        }
    }
    environment{
        IMAGE_NAME = 'tarea-final'
        DH_REPO = 'dromerocl/tarea-final'
        GH_REPO = 'ghcr.io/dromerop/tarea-final'
        K8S_NAMESPACE = 'ns-daniel-romero'
        DEPLOYMENT = 'app-daniel-romero'
        DEPLOYMENT_TAG = 'daniel-romero'
    }
    stages {
        stage('CI - pnpm'){
            stages {
                stage('CI - Configuracion de pnpm y node'){
                    steps {
                        container('pnpm'){
                            sh '''
                                pnpm runtime set node 24 -g
                                node --version
                                pnpm --version
                            '''
                        }
                    }
                }
                stage('CI - Install'){
                    steps {
                        container('pnpm'){
                            sh '''
                                pnpm install --frozen-lockfile
                            '''
                        }
                    }
                }
                stage('CI - Revision de linter'){
                    steps {
                        container('pnpm'){
                            sh '''
                                pnpm lint
                            '''
                        }
                    }
                }
                stage('CI - Test'){
                    steps {
                        container('pnpm'){
                            sh '''
                                pnpm test
                            '''
                        }
                    }
                }
                stage('CI - Build'){
                    steps {
                        container('pnpm'){
                            sh '''
                                pnpm build
                            '''
                        }
                    }
                }
                stage('CI - Obtener semver'){
                    steps{
                        container('pnpm'){
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
        }
        stage('CD - Build y Push imagen') {
            steps {
                script {
                    if (!env.APP_SEMANTIC_VERSION?.trim()) {
                        error('APP_SEMANTIC_VERSION no esta definido')
                    }
                }
                container('buildkit'){
                    sh '''
                        export DOCKER_CONFIG=/docker-configs/dockerhub
                        test -s "${DOCKER_CONFIG}/config.json"

                        buildctl-daemonless.sh build \
                        --frontend dockerfile.v0 \
                        --local context=. \
                        --local dockerfile=. \
                        --output type=image,name=${DH_REPO}:latest,push=true

                        buildctl-daemonless.sh build \
                        --frontend dockerfile.v0 \
                        --local context=. \
                        --local dockerfile=. \
                        --output type=image,name=${DH_REPO}:daniel-romero,push=true

                        buildctl-daemonless.sh build \
                        --frontend dockerfile.v0 \
                        --local context=. \
                        --local dockerfile=. \
                        --output type=image,name=${DH_REPO}:${APP_SEMANTIC_VERSION},push=true

                        export DOCKER_CONFIG=/docker-configs/github
                        test -s "${DOCKER_CONFIG}/config.json"

                        buildctl-daemonless.sh build \
                        --frontend dockerfile.v0 \
                        --local context=. \
                        --local dockerfile=. \
                        --output type=image,name=${GH_REPO}:latest,push=true

                        buildctl-daemonless.sh build \
                        --frontend dockerfile.v0 \
                        --local context=. \
                        --local dockerfile=. \
                        --output type=image,name=${GH_REPO}:daniel-romero,push=true

                        buildctl-daemonless.sh build \
                        --frontend dockerfile.v0 \
                        --local context=. \
                        --local dockerfile=. \
                        --output type=image,name=${GH_REPO}:${APP_SEMANTIC_VERSION},push=true
                    '''
                }
            }
        }
        stage('CD - Despliegue en K8'){
            when {
                branch 'main'
            }
            steps {
                script {
                    if(!env.APP_SEMANTIC_VERSION?.trim()){
                        error('APP_SEMANTIC_VERSION no esta definido')
                    }
                }
                container('kubectl'){
                    withKubeConfig([credentialsId: 'credenciales-kubernetes']){
                        sh '''
//                            kubectl --server=https://10.96.0.1 -n ${K8S_NAMESPACE} set image deployment/${DEPLOYMENT} ${IMAGE_NAME}=${DH_REPO}:${DEPLOYMENT_TAG}
//                            kubectl --server=https://10.96.0.1 -n ${K8S_NAMESPACE} rollout status deployment/${DEPLOYMENT}
                        '''
                    }
                }
            }
        }

    }
}