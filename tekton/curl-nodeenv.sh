curl -X POST \
  http://tekton-el-nodeenv.ingress.jmllab.com:80 \
  -H 'Content-Type: application/json' \
  -H 'X-Hub-Signature: sha1=2da37dcb9404ff17b714ee7a505c384758ddeb7b' \
  -d '{
        "source":
        {
                "path": "."
        },
        "deploy":
        {
                "path": "deploy.yaml"
        },
        "image":
        { "url": "jmlambert78/nodeenv",
		  "tag": "5"
        },
	"git":
	{ "url": "https://github.com/jmlambert78/node-env", "revision": "stackato-3.6"
 	}
}'

