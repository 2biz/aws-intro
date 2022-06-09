resource "aws_elasticache_subnet_group" "sample-elasticache-subnet"{
  name = "sample-elasticache-subnet"
  subnet_ids = [aws_subnet.sample-subnet-private01.id, aws_subnet.sample-subnet-private02.id]
}

resource "aws_elasticache_replication_group" "sample-elasticache" {
  replication_group_id = "sample-elasticache"
  description          = "Sample ElastiCache"
  engine               = "redis"
  engine_version       = "6.x"
  parameter_group_name = "default.redis6.x.cluster.on"
  multi_az_enabled     = true
  automatic_failover_enabled = true
  node_type            = "cache.t3.micro"
  num_node_groups      = 2
  replicas_per_node_group = 2
  subnet_group_name    = aws_elasticache_subnet_group.sample-elasticache-subnet.name
  security_group_ids   = [aws_default_security_group.default.id]
}
