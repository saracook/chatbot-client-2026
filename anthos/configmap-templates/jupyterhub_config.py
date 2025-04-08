import os, pwd, grp 
import sys
import glob
import kubespawner
import kubernetes
from pprint import pprint

#import z2jh 

from tornado.httpclient import AsyncHTTPClient

AsyncHTTPClient.configure("tornado.curl_httpclient.CurlAsyncHTTPClient")

c.JupyterHub.spawner_class = 'kubespawner.KubeSpawner'

c.ConfigurableHTTPProxy.api_url = 'http://proxy-api.jupyter.svc.cluster.local:8001'
c.ConfigurableHTTPProxy.should_start = False

c.JupyterHub.cleanup_servers = False

c.JupyterHub.last_activity_interval = 60

#set manually
#c.JupyterHub.concurrent_spawn_limit = get_config('hub.concurrent-spawn-limit')

#active_server_limit = get_config('hub.active-server-limit', None)

#if active_server_limit is not None:
#    c.JupyterHub.active_server_limit = int(active_server_limit)

c.JupyterHub.ip = '10.152.68.110'
c.JupyterHub.port = 8081

c.JupyterHub.hub_ip = '0.0.0.0'

c.KubeSpawner.start_timeout = 180

#c.KubeSpawner.singleuser_image_spec = os.environ['SINGLEUSER_IMAGE']
c.KubeSpawner.image = 'us-docker.pkg.dev/srcc-nero-prod/docker-repo/jupyter-20.04:production'
#c.KubeSpawner.image_pull_secrets
#c.KubeSpawner.imagePullSecrets
c.KubeSpawner.image_pull_secrets = [{"name": "artifact-registry"}]
#c.KubeSpawner.singleuser.imagePullSecret.username = '_json_key'

#set pod hostname for notebook
c.KubeSpawner.pod_connect_ip = 'jupyter.{username}.svc.cluster.local'

#mount service account info - otherwise istio breaks
c.KubeSpawner.automount_service_account_token = True
#exclude proxy port from istio; uncomment if using a proxy
#c.KubeSpawner.extra_annotations = { "traffic.sidecar.istio.io/excludeOutboundPorts": "3128" }

#c.KubeSpawner.singleuser_extra_labels = get_config('singleuser.extra-labels', {})

#c.KubeSpawner.singleuser_fs_gid = 100

#pprint(KubeSpawner.user) 
#c.KubeSpawner.uid = 1028773
#c.KubeSpawner.gid = 1028773
#c.KubeSpawner.supplemental_gids = [2000000,2000013,2000035,2000036,2000037,2000062]

service_account_name = 'hub'

#c.KubeSpawner.singleuser_node_selector = ''
storage_type = 'dynamic'
if storage_type == 'dynamic':
    c.KubeSpawner.pvc_name_template = 'claim-{username}{servername}'
    c.KubeSpawner.storage_pvc_ensure = False
    storage_class = None
    if storage_class:
        c.KubeSpawner.user_storage_class = storage_class
    c.KubeSpawner.storage_access_modes = ['ReadWriteOnce']
    c.KubeSpawner.storage_capacity = '10Gi'

    c.KubeSpawner.volumes = [
         {
            'name': 'home',
            'persistentVolumeClaim': {
                'claimName': 'cephfs-static-home'
            }
        },
         {
            'name': 'modulefiles',
            'emptyDir': {}
        },
         {
            'name': 'temp',
            'emptyDir': {}
        },
        {
            'name': 'extrausers',
            'configMap': {
                'name': 'extrausers'
            }
         },
        {
            'name': 'munge-key',
            'secret': {
                'secretName': 'munge-key'
            }
         },
        {
            'name': 'munge-run',
            'emptyDir': {}
         },
        {
            'name': 'slurm-node-conf',
            'configMap': {
                'name': 'slurm-node-conf'
            }
         },
         {
            'name': 'share-pi',
            'persistentVolumeClaim': {
                'claimName': 'cephfs-static-pi'
            }
        },
        {
            'name': 'share-sw',
            'persistentVolumeClaim': {
                'claimName': 'share-sw'
            }
        }
    ]
    c.KubeSpawner.volume_mounts = [
        {
            'mountPath': '/usr/share/lmod/lmod/modulefiles',
            'name': 'modulefiles'
        },
        {
            'mountPath': '/tmp',
            'name': 'temp'
        },
        {
            'mountPath': '/var/lib/extrausers',
            'name': 'extrausers'
        },
        {
            'mountPath': '/var/run/munge',
            'name': 'munge-run'
        },
        {
            'mountPath': '/local/munge-key',
            'name': 'munge-key'
        },
        {
            'mountPath': '/etc/slurm',
            'name': 'slurm-node-conf'
        },
        {
            'mountPath': '/share/pi',
            'name': 'share-pi',
            'subPath': 'pi'
        },
        {
            'mountPath': '/share/data',
            'name': 'share-pi',
            'subPath': 'data'
        },
        {
            'mountPath': '/home',
            'name': 'home'
        },
        {
            'mountPath': '/share/sw',
            'name': 'share-sw',
            'subPath': 'data/share/sw'
        }
    ]

#c.KubeSpawner.volumes.extend(get_config('singleuser.storage.extra-volumes', []))
#c.KubeSpawner.volume_mounts.extend(get_config('singleuser.storage.extra-volume-mounts', []))

#lifecycle_hooks = get_config('singleuser.lifecycle-hooks')
#if lifecycle_hooks:
#    c.KubeSpawner.singleuser_lifecycle_hooks = lifecycle_hooks

#init_containers = get_config('singleuser.init-containers')
#if init_containers:
#    c.KubeSpawner.singleuser_init_containers.extend(init_containers)

c.KubeSpawner.hub_connect_ip = 'hub.jupyter.svc.cluster.local'
#os.environ['HUB_SERVICE_HOST']
c.KubeSpawner.hub_connect_port = int(os.environ['HUB_SERVICE_PORT'])

c.JupyterHub.hub_connect_ip = 'hub.jupyter.svc.cluster.local'
#os.environ['HUB_SERVICE_HOST']
#JupyterHub.hub_connect_port is depcreated; use JupyterHub.hub_connect_url
#c.JupyterHub.hub_connect_port = int(os.environ['HUB_SERVICE_PORT'])
c.JupyterHub.hub_connect_url = 'http://hub.jupyter.svc.cluster.local:8081'

c.KubeSpawner.mem_limit = '96G'
c.KubeSpawner.mem_guarantee = '1G'
c.KubeSpawner.cpu_limit = 16
c.KubeSpawner.cpu_guarantee = 1

auth_type = 'google'
email_domain = 'local'

if auth_type == 'google':
    c.JupyterHub.authenticator_class = 'oauthenticator.GoogleOAuthenticator'
    c.GoogleOAuthenticator.client_id = '802938244258-uce3v51n1ts3n8biihg6412toi7ngego.apps.googleusercontent.com'
    c.GoogleOAuthenticator.client_secret = 'UcvYtPbkyfXdRLN-ZtTqddHz'
    c.GoogleOAuthenticator.oauth_callback_url = 'https://www.onprem.carina.stanford.edu/hub/oauth_callback'
    c.GoogleOAuthenticator.hosted_domain = 'stanford.edu'
    c.GoogleOAuthenticator.login_service = 'Stanford University'
    email_domain = 'stanford.edu'
elif auth_type == 'github':
    c.JupyterHub.authenticator_class = 'oauthenticator.GitHubOAuthenticator'
    c.GitHubOAuthenticator.oauth_callback_url = get_config('auth.github.callback-url')
    c.GitHubOAuthenticator.client_id = get_config('auth.github.client-id')
    c.GitHubOAuthenticator.client_secret = get_config('auth.github.client-secret')
elif auth_type == 'cilogon':
    c.JupyterHub.authenticator_class = 'oauthenticator.CILogonOAuthenticator'
    c.CILogonOAuthenticator.oauth_callback_url = get_config('auth.cilogon.callback-url')
    c.CILogonOAuthenticator.client_id = get_config('auth.cilogon.client-id')
    c.CILogonOAuthenticator.client_secret = get_config('auth.cilogon.client-secret')
elif auth_type == 'gitlab':
    c.JupyterHub.authenticator_class = 'oauthenticator.gitlab.GitLabOAuthenticator'
    c.GitLabOAuthenticator.oauth_callback_url = get_config('auth.gitlab.callback-url')
    c.GitLabOAuthenticator.client_id = get_config('auth.gitlab.client-id')
    c.GitLabOAuthenticator.client_secret = get_config('auth.gitlab.client-secret')
elif auth_type == 'mediawiki':
    c.JupyterHub.authenticator_class = 'oauthenticator.mediawiki.MWOAuthenticator'
    c.MWOAuthenticator.client_id = get_config('auth.mediawiki.client-id')
    c.MWOAuthenticator.client_secret = get_config('auth.mediawiki.client-secret')
    c.MWOAuthenticator.index_url = get_config('auth.mediawiki.index-url')
elif auth_type == 'globus':
    c.JupyterHub.authenticator_class = 'oauthenticator.globus.GlobusOAuthenticator'
    c.GlobusOAuthenticator.oauth_callback_url = get_config('auth.globus.callback-url')
    c.GlobusOAuthenticator.client_id = get_config('auth.globus.client-id')
    c.GlobusOAuthenticator.client_secret = get_config('auth.globus.client-secret')
    c.GlobusOAuthenticator.identity_provider = get_config('auth.globus.identity-provider', '')
elif auth_type == 'hmac':
    c.JupyterHub.authenticator_class = 'hmacauthenticator.HMACAuthenticator'
    c.HMACAuthenticator.secret_key = bytes.fromhex(get_config('auth.hmac.secret-key'))
elif auth_type == 'dummy':
    c.JupyterHub.authenticator_class = 'dummyauthenticator.DummyAuthenticator'
    c.DummyAuthenticator.password = get_config('auth.dummy.password', None)
elif auth_type == 'tmp':
    c.JupyterHub.authenticator_class = 'tmpauthenticator.TmpAuthenticator'
elif auth_type == 'lti':
    c.JupyterHub.authenticator_class = 'ltiauthenticator.LTIAuthenticator'
    c.LTIAuthenticator.consumers = get_config('auth.lti.consumers')
elif auth_type == 'custom':
    full_class_name = get_config('auth.custom.class-name')
    c.JupyterHub.authenticator_class = full_class_name
    auth_class_name = full_class_name.rsplit('.', 1)[-1]
    auth_config = c[auth_class_name]
    auth_config.update(get_config('auth.custom.config') or {})
else:
    raise ValueError("Unhandled auth type: %r" % auth_type)

c.Authenticator.enable_auth_state = False

def generate_user_email(spawner):
    """
    Used as the EMAIL environment variable
    """
    return '{username}@{domain}'.format(
        username=spawner.user.name, domain=email_domain
    )

def generate_user_name(spawner):
    """
    Used as GIT_AUTHOR_NAME and GIT_COMMITTER_NAME environment variables
    """
    return spawner.user.name

c.KubeSpawner.environment = {
    'EMAIL': generate_user_email,
    'GIT_AUTHOR_NAME': generate_user_name,
    'GIT_COMMITTER_NAME': generate_user_name
}

#c.KubeSpawner.environment.update(get_config('singleuser.extra-env', {}))

c.JupyterHub.admin_access = True
#consider carving this out into a different file
c.Authenticator.admin_users = ['vmeau','neals','addiso','wlaw']
c.Authenticator.allowed_users = ['mpiercy','lesleyp','sbogdan']

def my_hook(spawner):
   username = spawner.user.name
   myuid = pwd.getpwnam(username).pw_uid
   mygroups = [g.gr_gid for g in grp.getgrall() if username in g.gr_mem]
   mygid = pwd.getpwnam(username).pw_gid
   spawner.uid = myuid
   spawner.gid = mygid
   spawner.supplemental_gids = mygroups

c.KubeSpawner.pre_spawn_hook = my_hook
c.KubeSpawner.enable_user_namespaces = True
c.KubeSpawner.user_namespace_template = '{username}'

pprint(vars(c.KubeSpawner))
pprint(vars(c.Authenticator))
pprint(vars(c.JupyterHub))


c.JupyterHub.base_url = '/'

#new in jupyter 2.0 - roles
c.JupyterHub.load_roles = [
    {
        "name": "jupyterhub-idle-culler-role",
        "scopes": [
            "list:users",
            "read:users:activity",
            "read:servers",
            "delete:servers",
            # "admin:users", # if using --cull-users
        ],
        # assignment of role's permissions to:
        "services": ["jupyterhub-idle-culler-service"],
    }
]

c.JupyterHub.services = [
    {
        "name": "jupyterhub-idle-culler-service",
        "command": [
            sys.executable,
            "-m", "jupyterhub_idle_culler",
            "--timeout=3600",
        ],
        # "admin": True,
    }
]


#cull_timeout = '3600'
#cull_every = '600'
#cull_cmd = [
#        '/usr/local/bin/cull_idle_servers.py',
#        '--timeout=%s' % cull_timeout,
#        '--cull-every=%s' % cull_every,
#        '--url=http://127.0.0.1:8081' + c.JupyterHub.base_url + 'hub/api'
#    ]
#cull_cmd.append('--cull-users')
#c.JupyterHub.services.append({
#        'name': 'cull-idle',
#        'admin': True,
#        'command': cull_cmd,
#    })

#for name, service in get_config('hub.services', {}).items():
#    api_token = get_secret('services.token.%s' % name)
#    service.setdefault('name', name)
#    if api_token:
#        service['api_token'] = api_token
#    service['api_token'] = api_token
#    c.JupyterHub.services.append(service)


c.JupyterHub.db_url = 'sqlite:///jupyterhub.sqlite'
c.JupyterHub.db.type = 'sqlite-pvc'

#cmd = 'jupyterhub-singleuser'
cmd = '/usr/local/bin/new-start-notebook.sh'
if cmd:
    c.Spawner.cmd = cmd

#default_url = get_config('singleuser.default-url', None)
c.Spawner.default_url = "/lab"
#if default_url:
#    c.Spawner.default_url = default_url

#cloud_metadata = False

#if not cloud_metadata.get('enabled', False):
network_tools_image_name = 'jupyterhub/k8s-network-tools'
network_tools_image_tag = 'latest'
#ip_block_container = client.V1Container(
#        name="block-cloud-metadata",
#        image=f"{network_tools_image_name}:{network_tools_image_tag}",
#        command=[
#            'iptables',
#            '-A', 'OUTPUT',
#            '-d', cloud_metadata.get('ip', '169.254.169.254'),
#            '-j', 'DROP'
#        ],
#        security_context=client.V1SecurityContext(
#            privileged=True,
#            run_as_user=0,
#            capabilities=client.V1Capabilities(add=['NET_ADMIN'])
#        )
#    )

#c.KubeSpawner.singleuser_init_containers.append(ip_block_container)

scheduler_strategy = 'spread'

if scheduler_strategy == 'pack':
    c.KubeSpawner.extra_pod_config = {
        'affinity': {
            'podAffinity': {
                'preferredDuringSchedulingIgnoredDuringExecution': [{
                    'weight': 100,
                    'podAffinityTerm': {
                        'labelSelector': {
                            'matchExpressions': [{
                                'key': 'component',
                                'operator': 'In',
                                'values': ['singleuser-server']
                            }]
                        },
                        'topologyKey': 'kubernetes.io/hostname'
                    }
                }],
            }
        }
    }
else:
    c.KubeSpawner.extra_pod_config = {}
extra_configs = sorted(glob.glob('/etc/jupyterhub/config/hub.extra-config.*.py'))
for ec in extra_configs:
    load_subconfig(ec)
