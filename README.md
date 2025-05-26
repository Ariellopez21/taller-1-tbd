# Diseño

El proyecto utiliza `Python` como lenguaje de programación principal, gestionando la base de datos a través de `PostgreSQL`.

Se utiliza como gestor del entorno y dependencias a `uv` y a través del mismo se instalan los siguientes paquetes:

- `SQLAlchemy`: Define los modelos y gestiona la interacción con PostgreSQL.
- `Alembic`: Gestor de migraciones que permite realizar cambios en la base de datos de manera segura.
- `Faker`: Para la generación de datos aleatorios.
- `psycopg2`: Para comunicarse con la base de datos.

Se utilizan los siguientes archivos `.py`:

- `main.py`: Funciona como Script para ejecutar el proyecto desde terminal y hacer uso de las funciones CRUD implementadas.
- `crud.py`: Contiene las operaciones GET, POST, PATCH solicitadas para este proyecto.
- `database.py`: Instancia la conexión entre la base de datos y el proyecto.
- `models.py`: Define los modelos de clases de SQLAlchemy que se usan para representar las tablas en la base de datos. 

# Configuración inicial

La configuración inicial ya asume que el profesor tiene conocimientos previos de lo que realiza cada comando a utilizar y que ha instalado con anterioridad lo que se requiere para que este proyecto funcione, excepto en el caso de Alembic que será un poco explicado.

## Clonar el repositorio

```
$ git clone https://github.com/Ariellopez21/taller-1-tbd
```

## Crear el entorno virtual de python con uv

```
$ uv venv .venv
$ source .venv/bin/activate
$ uv sync
```

## Configuración de Alembic

En la configuración del archivo `alembic.ini` la línea que determina la base de datos a utilizar es:

```
sqlalchemy.url = postgresql+psycopg2:///iot_devices
```

Se asume que el profesor tiene la configuración de usuario con permisos necesarios para ejecutar los siguientes comandos:

```
$ createdb iot_devices
```

> Sí ya existe la base de datos, la tiene que dropear con `dropdb iot_devices`.

También se asume que si el profesor puede utilizar los comandos anteriores, no debe tener problemas para usar `sqlalchemy.url = postgresql+psycopg2:///iot_devices`, ya que el usuario tiene los permisos para ingresar sin contraseña porque el nombre del mismo es el del S.O. actual.

### Migración V1

Debe ejecutar el siguiente comando para ver la primera migración:

```
alembic upgrade a0d479e947b1
```

> No ejecute main.py aún.

### Migración V2

Luego de crear la primera versión de alembic, y corroborar que la base de datos existe, debe ejecutar:

```
alembic upgrade head
```

Así, la migración de la base de datos estará en su segunda versión (y final).

> A partir de ahora puede utilizar main.py


# Ejecutar archivo main.py

Debe estar en la carpeta `taller-1`, tener activo el entorno virtual `.venv` y ejecutar la siguiente linea:

```
(.venv):~/taller-1$ python3 -m app.main
```

## Funcionamiento del Script

Se ejecuta inicialmente una creación de datos en la base de datos `iot_devices` haciendo uso de todas las funciones POST.

Luego, se accede a la interfaz del terminal donde se puedes realizar las consultas en `crud.py`.

Las consultas interactivas son funciones GET.

Además de ellas, se pueden utilizar las funciones PATCH relaciondas a la asociación y desasociación de `Dispositivos` a `GruposDispositivos`.

# Estructura del proyecto

Esta debe ser tu estructura del proyecto para la correcta ejecución de los pasos anteriores.
```
TALLER-1/
├── .venv/
├── alembic/
│   ├── versions/
│   ├── env.py
│   └── script.py.mako
├── app/
│   ├── crud.py
│   ├── database.py
│   ├── main.py
│   └── models.py
├── alembic.ini
├── pyproject.toml
├── uv.lock
├── README.md
└── .gitignore
```

> Ariel López S. - arilopez@umag.cl