. /lib/dracut-lib.sh

ENCR_PART=data
NEWROOT=${NEWROOT:-"/sysroot"}
DEVICE=/dev/vda4 # TODO:
KEY=$NEWROOT/etc/cryptsetup-keys.d/decrypted.key # TODO:

mkdir /etc/repart.d
echo -n "[Partition]
Type=linux-generic
Format=ext4
Encrypt=key-file
MakeDirectories=/work /upper" > /etc/repart.d/encr.conf

systemd-repart --dry-run=no --key-file=$KEY --no-pager --definitions=/etc/repart.d

/usr/lib/systemd/systemd-cryptsetup attach decrypted $DEVICE $KEY
mkdir -p /run/$ENCR_PART
mount /dev/mapper/decrypted /run/$ENCR_PART

chcon system_u:object_r:root_t:s0 /run/$ENCR_PART/upper
chcon system_u:object_r:root_t:s0 /run/$ENCR_PART/work

mkdir /run/oldroot
mount --make-private /
mount --make-private $NEWROOT
mount --move $NEWROOT /run/oldroot
mount -t overlay overlay -o lowerdir=/run/oldroot,upperdir=/run/$ENCR_PART/upper,workdir=/run/$ENCR_PART/work $NEWROOT