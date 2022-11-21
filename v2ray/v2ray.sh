#!/bin/sh

tmp_dir=$( mktemp -d )
machine=$( uname -m )
if [ "${machine}" = "x86_64" ]; then
    v2ray_name="v2ray-linux-64.zip"
else
    v2ray_name="v2ray-linux-arm64-v8a.zip"
fi


# Download and install V2Ray
mkdir ${tmp_dir}
wget -q https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip -O ${tmp_dir}/v2ray-linux.zip

unzip ${tmp_dir}/v2ray-linux.zip -d ${tmp_dir}
cp -r ${tmp_dir}/v2ray /usr/bin/v2ray
cp -r ${tmp_dir}/v2ctl /usr/bin/v2ctl
cp -r ${tmp_dir}/geo* /usr/bin/

# Remove temporary directory
rm -rf ${tmp_dir}/

# V2Ray new configuration
mkdir -p /etc/v2ray
cat << EOF > /etc/v2ray/config.json
{
    "inbounds": [
        {
            "port": 10810,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "628d8e31-d9e0-4b8b-8f0e-1e314ae11dce",
                        "alterId": 64
                    }
                ],
                "disableInsecureEncryption": true
            },
            "streamSettings": {
                "network": "ws"
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
EOF

echo Done
