"""
func.py
==========================================================================
Plantilla base de OCI Function (Python + fdk).
Base template for an OCI Function (Python + fdk).

- Autenticación / Auth: Resource Principal. La Function se autentica con su
  propia identidad de OCI (sin credenciales almacenadas). Úsalo para crear
  clientes del SDK de OCI y llamar a otros servicios.
  The Function authenticates with its own OCI identity (no stored
  credentials). Use it to build OCI SDK clients and call other services.

- Invocación / Invocation:
    * On-demand: `fn invoke`, API o HTTP, con o sin payload JSON.
    * Programada / Scheduled: OCI Resource Scheduler, sin payload
      (si schedule.enabled = true en function.json).

- Configuración / Config: las variables de entorno provienen del bloque
  `config` de function.json (Terraform las inyecta en la Function).
==========================================================================
"""

import io
import os
import json
import logging

import oci
from fdk import response

logging.basicConfig()
log = logging.getLogger("fn-hello")
log.setLevel(logging.INFO)


def _read_payload(data: io.BytesIO) -> dict:
    """Parsea el body JSON si existe / Parse JSON body if present."""
    if data is None:
        return {}
    try:
        raw = data.getvalue()
        return json.loads(raw) if raw else {}
    except (ValueError, AttributeError):
        return {}


def handler(ctx, data: io.BytesIO = None):
    # Variables de entorno definidas en function.json -> config
    greeting = os.environ.get("GREETING", "Hello from OCI Functions")

    body = _read_payload(data)
    name = body.get("name", "world")

    # --- Resource Principal: identidad propia de la Function -----------------
    # Descomenta para usar el SDK de OCI con la identidad de la Function.
    # Uncomment to use the OCI SDK with the Function's own identity.
    #
    #   signer = oci.auth.signers.get_resource_principals_signer()
    #   object_storage = oci.object_storage.ObjectStorageClient(config={}, signer=signer)
    #   namespace = object_storage.get_namespace().data
    #   ... llama a otros servicios OCI aquí / call other OCI services here ...
    #
    # Recuerda otorgar permisos en terraform/iam.tf (dynamic group + policy).

    # TODO: lógica de negocio / business logic
    result = {"message": f"{greeting}, {name}!"}

    log.info(f"Respuesta / Response: {result}")
    return response.Response(
        ctx,
        response_data=json.dumps(result),
        headers={"Content-Type": "application/json"},
    )
