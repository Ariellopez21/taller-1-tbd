

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

Sí ya la tiene se debe dropear `dropdb iot_devices`.

También se asume que si el profesor puede utilizar los comandos anteriores, no debe tener problemas para usar `sqlalchemy.url = postgresql+psycopg2:///iot_devices`, ya que el usuario tiene los permisos para ingresar sin contraseña porque el nombre del mismo es el del S.O. actual.

Finalmente, debe usar `alembic upgrade head` para aplicar las migraciones hasta la más reciente del repositorio a la base de datos aplicada.

# Ejecutar archivo main.py

## Funcionamiento del Script

Se ejecuta inicialmente una creación de datos en la base de datos `iot_devices` haciendo uso de todas las funciones POST.

Luego, se accede a la interfaz del terminal donde se puedes realizar las consultas solicitadas en `crud.py`.
