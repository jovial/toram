to build:

```
mkdir ~/elements && cd ~/elements
git clone https://github.com/jovial/toram
export ELEMENTS_PATH=~/elements
export TMP_DIR=/opt2/will/tmp # only if you don't want to use /tmp
disk-image-create centos7 epel selinux-permissive dhcp-all-interfaces vm toram  --image-cache /opt2/will/.cache/dib -o centos

```



notes:

install-static will destroy symlinks, so if you try to copy to /lib when /lib
is a symlink to /usr/lib then things will break

