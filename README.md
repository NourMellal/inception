# Inception Project - 42 School

## 📦 Project Goal

The Inception project consists of setting up a containerized infrastructure using **Docker** and **Docker Compose**, with mandatory services including:

* **Nginx** (HTTPS web server)
* **WordPress** (PHP-FPM + WP-CLI based installation)
* **MariaDB** (MySQL-compatible database)

Each service must run in its own container, defined and orchestrated through Docker Compose. The goal is to understand and apply containerization principles with security, modularity, and service separation in mind.

---

## 🐳 Understanding Containerization

### What is a Container?

A **container** is a lightweight, isolated environment that packages software with all its dependencies. Containers run as isolated **processes** on a shared host kernel, using:

* **Namespaces** for isolation
* **cgroups** for resource limits
* **Union filesystems** (like OverlayFS) for layered storage

Unlike **VMs**, containers do not run a full OS—this makes them faster and more resource-efficient.

### Docker vs Docker Compose

| Feature       | Docker                             | Docker Compose                                |
| ------------- | ---------------------------------- | --------------------------------------------- |
| Tool type     | CLI for managing single containers | Orchestrator for multi-container environments |
| Configuration | Manual via `docker run` flags      | Declarative YAML file (`docker-compose.yml`)  |
| Networking    | Manual setup                       | Auto bridge network + service name DNS        |
| Data Volumes  | Manual `-v` flags                  | Centralized under `volumes:` section          |
| Use case      | One-off containers                 | Defined infrastructure (web + db + cache)     |

---

## 🏗️ Project Architecture

### Services Breakdown:

1. **MariaDB**

   * Stores all WordPress data.
   * Uses a volume for persistence: `/var/lib/mysql`
   * Set via environment variables: `MYSQL_ROOT_PASSWORD`, `MYSQL_DATABASE`, etc.

2. **WordPress + PHP-FPM**

   * Handles PHP execution and WordPress site logic.
   * Uses `WP-CLI` in entrypoint to auto-install WordPress.
   * Needs to connect to MariaDB via internal hostname `mariadb`.

3. **Nginx**

   * Handles HTTPS traffic and forwards PHP requests to WordPress.
   * Uses a **self-signed TLS certificate**.
   * Shares a volume with the WordPress container to serve static files.

### Volumes Example:

```yaml
volumes:
  mariadb_data:
    driver: local
    driver_opts:
      type: none
      device: /home/USERNAME/data/mariadb
      o: bind
  wordpress_data:
    driver: local
    driver_opts:
      type: none
      device: /home/USERNAME/data/wordpress
      o: bind
```

This ensures database and WP files are persistent across container restarts.

### Networks

All services are on the same **Docker bridge network**, enabling inter-container DNS resolution using service names.

---

## 🔐 Security & HTTPS

* HTTPS is configured using **self-signed certs**.
* Browsers may show a warning ("Not Secure") because the certificate is not signed by a trusted authority.
* Nginx is configured to:

  * Listen on `443`
  * Redirect HTTP → HTTPS (optional)
  * Use `ssl_certificate` and `ssl_certificate_key` paths

---

## ⚙️ Best Practices Followed

* One process per container (no `tail -f`, `sleep`, or background hacks)
* Use of `restart: always` for resilient services
* Use of `.env` files for secure and configurable environment variables
* Avoid exposing database ports to the host — only expose Nginx 443
* Version-pinned base images (e.g. `nginx:1.25-alpine`, not `latest`)

---

## 🚀 Bonus (if implemented)

* **Redis**: containerized in-memory cache used by WordPress via plugin
* **FTP (vsftpd)**: container with access to WordPress volume
* **Adminer**: database management UI connected to MariaDB
* **Static HTML site**: a minimal Nginx container to serve static content

---

## 💡 Notes

* Be sure to add `127.0.0.1 your-login.42.fr` to `/etc/hosts`
* All containers are built via individual Dockerfiles (no prebuilt images)
* WordPress is installed via `wp core install` and auto-configured at startup

---

## 📚 References

* Docker Docs: [https://docs.docker.com](https://docs.docker.com)
* WP-CLI: [https://wp-cli.org/](https://wp-cli.org/)
* Inception project guidelines from 42 Network
