import json
import logging

log = logging.getLogger(__name__)

def get_and_log_environment(env_file):
    """Grab and log environment for to use when executing command line.

    The shell environment is saved into a file at an appropriate place in the Dockerfile.

    Args:
        log (GearToolkitContext().log): logger set up by Gear Toolkit

    Returns: (nothing)
    """
    with open(env_file, "r") as f:
        environ = json.load(f)

        # Add environment to log if debugging
        kv = ""
        for k, v in environ.items():
            kv += k + "=" + v + " "
        log.debug("Environment: " + kv)

    return environ
