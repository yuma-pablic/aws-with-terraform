resource "aws_security_group" "sbcntr-sg-ingress" {
    vpc_id = aws_vpc.sbcntrVpc.id
    description = "Security group for ingress"
    name = "ingress"
    tags = {
      "Name" ="sbcntr-sg-ingress"
    }
}

resource "aws_security_group_rule" "inbaund" {
    type        = "ingress"
    cidr_blocks =[
        "0.0.0.0/0"
    ]
    description = "Allow all outbound traffic by default"
    from_port = 80
    to_port = 80
    protocol = "-1"
    security_group_id = aws_security_group.sbcntr-sg-ingress.id
}

resource "aws_security_group_rule" "egress-v4" {
    type = "egress"
    cidr_blocks = [
        "0.0.0.0/0"
    ]
    description = "from 0.0.0.0/0:80"
    from_port = 80
    protocol = "tcp"
    to_port = 80
    security_group_id = aws_security_group.sbcntr-sg-ingress.id 
}

resource "aws_security_group_rule" "egress-v6" {
    type = "egress"
    ipv6_cidr_blocks = ["::/0"]
    description = "from ::/0:80"
    from_port = 80
    protocol = "tcp"
    to_port = 80
    security_group_id = aws_security_group.sbcntr-sg-ingress.id
}

# 管理用サーバ向けのセキュリティグループの生成
resource "aws_security_group" "sbcntr-sg-management" {
    vpc_id = aws_vpc.sbcntrVpc.id
    description = "Security Group of management server"
    name = "management"
    tags = {
      "Name" = "sbcntr-sg-management"
    }
}

resource "aws_security_group_rule" "management-egress-v4" {
    type = "egress"
    cidr_blocks = [
        "0.0.0.0/0"
    ]
    description = "from 0.0.0.0/0:80"
    from_port = 80
    protocol = "-1"
    to_port = 80
    security_group_id = aws_security_group.sbcntr-sg-management.id 
}

## バックエンドコンテナアプリ用セキュリティグループの生成
resource "aws_security_group" "sbcntr-sg-backend" {
   vpc_id = aws_vpc.sbcntrVpc.id
    description = "Security Group of backend app"
    name = "container"
    tags = {
      "Name" = "sbcntr-sg-container"
    }
}

resource "aws_security_group_rule" "backdend-egress-v4" {
    type = "egress"
    cidr_blocks = [
        "0.0.0.0/0"
    ]
    description = "Allow all outbound traffic by default"
    from_port = 80
    protocol = "-1"
    to_port = 80
    security_group_id = aws_security_group.sbcntr-sg-backend.id 
}

## フロントエンドコンテナアプリ用セキュリティグループの生成
resource "aws_security_group" "sbcntr-sg-front-container" {
    vpc_id = aws_vpc.sbcntrVpc.id
    description = "Security Group of front container app"
    name = "front-container"
    tags = {
      "Name" = "sbcntr-sg-container"
    }
}

resource "aws_security_group_rule" "frontend-egress-v4" {
  type = "egress"
    cidr_blocks = [
        "0.0.0.0/0"
    ]
    description = "Allow all outbound traffic by default"
    from_port = 80
    protocol = "-1"
    to_port = 80
    security_group_id = aws_security_group.sbcntr-sg-front-container.id 
}

## 内部用ロードバランサ用のセキュリティグループの生成
resource "aws_security_group" "sbcntr-sg-internal" {
    vpc_id = aws_vpc.sbcntrVpc.id
    description = "Security group for internal load balancer"
    name = "internal"
    tags = {
      "Name" = "sbcntr-sg-internal"
    }
}

resource "aws_security_group_rule" "internal-egress-v4" {
    type = "egress"
    cidr_blocks = [
        "0.0.0.0/0"
    ]
    description = "Allow all outbound traffic by default"
    from_port = 80
    protocol = "-1"
    to_port = 80
    security_group_id = aws_security_group.sbcntr-sg-internal.id 
}

## DB用セキュリティグループの生成
resource "aws_security_group" "sbcntr-sg-db" {
    vpc_id = aws_vpc.sbcntrVpc.id
    description = "Security Group of database"
    name = "database"
    tags = {
      "Name" = "sbcntr-sg-db"
    }
}

resource "aws_security_group_rule" "db-egress-v4" {
    type = "egress"
    cidr_blocks = [
        "0.0.0.0/0"
    ]
    description = "Allow all outbound traffic by default"
    from_port = 80
    protocol = "-1"
    to_port = 80
    security_group_id = aws_security_group.sbcntr-sg-db.id 
}

## VPCエンドポイント用セキュリティグループの生成
resource "aws_security_group" "sbcntr-sg-vpce" {
    name = "egress"
    description = "Security Group of VPC Endpoint"
    vpc_id = aws_vpc.sbcntrVpc.id
}

resource "aws_security_group_rule" "sbcntr-sg-vpce-egress" {
    type = "egress"
    cidr_blocks = [
        "0.0.0.0/0"
    ]
    description = "Allow all outbound traffic by default"
    from_port = 80
    protocol = "-1"
    to_port = 80
    security_group_id = aws_security_group.sbcntr-sg-vpce.id
}


# ルール紐付け
## Internet LB -> Front Container
resource "aws_security_group_rule" "sbcntr-sg-frontcontainer-from-sg-ingress" {
    type = "ingress"
    description = "HTTP for Ingress"
    from_port = 80
    source_security_group_id = aws_security_group.sbcntr-sg-ingress.id
    security_group_id = aws_security_group.sbcntr-sg-front-container.id
    protocol = "-1"
    to_port = 80
}


## Front Container -> Internal LB
resource "aws_security_group_rule" "sbcntr-sg-ingress-from-sg-frontcontainer" {
    type = "ingress"
    description = "HTTP for front container"
    from_port = 80
    source_security_group_id = aws_security_group.sbcntr-sg-front-container.id
    security_group_id = aws_security_group.sbcntr-sg-internal.id
    protocol = "-1"
    to_port = 80
}

## Internal LB -> Back Container
resource "aws_security_group_rule" "sbcntr-sg-internal-from-sg-backcontainer" {
    type = "ingress"
    description = "HTTP for internal lb"
    from_port = 80
    security_group_id = aws_security_group.sbcntr-sg-internal.id
    source_security_group_id = aws_security_group.sbcntr-sg-backend.id
    protocol = "tcp"
    to_port = 80
}

## Back container -> DB
resource "aws_security_group_rule" "sbcntr-sg-backcontainer-from-db" {
    type = "ingress"
    description = "MySQL protocol from backend App"
    from_port = 3306
    source_security_group_id = aws_security_group.sbcntr-sg-backend.id
    security_group_id = aws_security_group.sbcntr-sg-db.id
    protocol = "tcp"
    to_port = 3306
}

## Front container -> DB
resource "aws_security_group_rule" "sbcntr-sg-frontcontainer-from-db" {
    type = "ingress"
    description = "MySQL protocol from management server"
    from_port = 3306
    source_security_group_id = aws_security_group.sbcntr-sg-front-container.id
    security_group_id = aws_security_group.sbcntr-sg-db.id
    protocol = "tcp"
    to_port = 3306
}



## Management server -> db
resource "aws_security_group_rule" "sbcntr-sg-management-from-db" {
    type = "ingress"
    description = "MySQL protocol from management server"
    from_port = 3306
    source_security_group_id = aws_security_group.sbcntr-sg-management.id
    security_group_id = aws_security_group.sbcntr-sg-db.id
    protocol = "tcp"
    to_port = 3306
}

## Management server -> Internal LB
resource "aws_security_group_rule" "sbcntr-sg-management-from-internal" {
     type = "ingress"
    description = "MySQL protocol from management server"
    from_port = 3306
    source_security_group_id = aws_security_group.sbcntr-sg-management.id
    security_group_id = aws_security_group.sbcntr-sg-internal.id
    protocol = "tcp"
    to_port = 3306 
}


 ### Back container -> VPC endpoint
 resource "aws_security_group_rule" "sbcntr-sg-back-container-from-vpce" {
    type = "ingress"
    description = " HTTPS for Container App"
    from_port = 443
    source_security_group_id = aws_security_group.sbcntr-sg-backend.id
    security_group_id = aws_security_group.sbcntr-sg-vpce.id
    protocol = "tcp"
    to_port = 443
}

 ### Front container -> VPC endpoint
 resource "aws_security_group_rule" "sbcntr-sg-front-container-from-vpce" {
    type = "ingress"
    description = "HTTPS for Front Container App"
    from_port = 443
    source_security_group_id = aws_security_group.sbcntr-sg-front-container.id
    security_group_id = aws_security_group.sbcntr-sg-vpce.id
    protocol = "tcp"
    to_port = 443
}

### Management Server -> VPC endpoint
resource "aws_security_group_rule" "sbcntr-sg-management-server-from-vpce" {
    type = "ingress"
    description = "HTTPS for management server"
    from_port = 443
    source_security_group_id = aws_security_group.sbcntr-sg-management.id
    security_group_id = aws_security_group.sbcntr-sg-vpce.id
    protocol = "tcp"
    to_port = 443
}

### Management -> Internal
resource "aws_security_group_rule" "sbcntr-sg-management-server-from-internal" {
    type = "ingress"
    description = "HTTPS for management server"
    from_port = 10080
    source_security_group_id = aws_security_group.sbcntr-sg-management.id
    security_group_id = aws_security_group.sbcntr-sg-internal.id
    protocol = "tcp"
    to_port = 10080
}