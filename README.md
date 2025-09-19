# FreeSWITCH en ECS/Fargate (Ready para Amazon Chime Voice Connector)

Este repo contiene una imagen de Docker con **FreeSWITCH** y **configuración ya funcional**

> **Importante**: Este repo incluye `/build/freeswitch/conf` con perfiles y dialplans listos para **Amazon Chime Voice Connector** (inbound/outbound).

---

## 📁 Estructura

freeswitch-fargate/
├─ Dockerfile
├─ docker/
│ └─ entrypoint.sh
├─ build/
│ └─ freeswitch/ # Copiado desde la EC2 (bin, mod, conf, htdocs, scripts)
│ ├─ bin/
│ ├─ mod/
│ ├─ conf/ # Perfiles y dialplans probados con VC
│ ├─ htdocs/
│ └─ scripts/
├─ overlay-conf/ # (opcional) overrides para conf
├─ .gitignore
├─ .dockerignore
└─ README.md


- **`build/freeswitch/conf`** trae la config funcional:
  - `sip_profiles/external.xml` y/o `sip_profiles/external/*.xml` (gateway `awsvc` hacia Voice Connector).
  - `dialplan/public.xml` (inbound desde VC).
  - `dialplan/default.xml` (outbound vía `sofia/gateway/awsvc`).
  - `vars.xml` con puertos/externals que usaste en EC2.

---

## ✅ Requisitos

- Docker 24+ (o compatible).
- Puertos locales disponibles para pruebas:
  - **SIP**: `5060/udp`, `5060/tcp` (y `5061/tcp` si TLS).
  - **RTP**: rango que uses en de conf (por defecto **10000–20000/udp**).
