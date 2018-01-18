COMPOSE_FILES ?= -f docker-compose0.yml \
                 -f virgil-services-developer/docker-compose.yml \
                 -f virgil-services-developer/build/docker-compose.yml \
                 -f virgil-services-developer-frontend/docker-compose.yml \
				 -f virgil-services-developer-frontend/build/docker-compose.yml \
                 -f docker-compose.yml \
                 -f docker-compose.override.yml

service_top:
	docker stats $($(docker ps --format={{.Names}} --filter "label=com.docker.compose.project=devportal_build")) --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}\t{{.PIDs}}"

service_up:
	docker-compose $(COMPOSE_FILES) up -d

service_build_frontend:
	docker-compose $(COMPOSE_FILES_FRONT) build virgil-developer-frontend

service_build_core:
	docker-compose $(COMPOSE_FILES_FRONT) build virgil-developer

service_build_gateway:
	docker-compose $(COMPOSE_FILES_FRONT) build virgil-api-gateway

service_build:
	docker-compose $(COMPOSE_FILES) build

service_status:
	docker-compose $(COMPOSE_FILES) ps

service_log:
	docker-compose $(COMPOSE_FILES) logs

service_developer_frontend_db_log:
	docker-compose $(COMPOSE_FILES) logs --follow virgil-developer-frontend-db

service_developer_frontend_log:
	docker-compose $(COMPOSE_FILES) logs --follow virgil-developer-frontend

service_api_gateway_log:
	docker-compose $(COMPOSE_FILES) logs --follow virgil-api-gateway

service_developer_core_log:
	docker-compose $(COMPOSE_FILES) logs --follow virgil-developer

service_developer_db_log:
	docker-compose $(COMPOSE_FILES) logs --follow virgil-developer-db

service_down:
	docker-compose $(COMPOSE_FILES) down --remove-orphans

service_stop:
	docker-compose $(COMPOSE_FILES) stop

service_start:
	docker-compose $(COMPOSE_FILES) start

service_restart:
	docker-compose $(COMPOSE_FILES) restart

service_config:
	docker-compose $(COMPOSE_FILES) config