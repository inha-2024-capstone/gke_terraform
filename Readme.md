## GKE 사용 방법 
### 아래의 API 활성화  
* Cloud SQL Admin API     
* Service Networking API        
* Cloud Resource Manager API       
* Compute Engine API       
* Kubernetes Engine API         
---
### 테라폼 GCP 인증
* IAM 및 관리자 접속  
* 서비스 계정에 소유자 또는 roles/iam.serviceAccountUser 및 roles/compute.networkViewer 추가        
* 이후 key를 발급받고 해당 json 파일의 path를 GOOGLE_APPLICATION_CREDENTIALS 의 환경변수로 설정        

### main.tf 작성
* 해당 파일에 프로젝트 id와 같은 변수 입력       

### 중요한 점
* GKE는 하나의 서브네트워크에서 동작한다. 다른 서브네트워크를 지정하지 말고 사용할 여러 개의 가용영역을 지정해주면 된다.       
* AWS 처럼 라우팅 테이블을 작성하지 않아도 된다.         
* NAT는 서브네트워크 레벨로 지정한다.          
* 노드 풀의 기본 SSD 크기는 100GB이다. 20GB로 지정해주자.      
* mysql을 프라이빗에서 사용하려면 VPC 피어링이 필요하다. AWS와 다르게 Cloud SQL은 지정한 서브넷의 IP 대역을 받는 것이 아니라 GCP가 관리하는 네트워크에 생성된다. 
이 네트워크와 연동하고자하는 VPC를 연결하는 **프라이빗 서비스 연결**이 필요하다. 