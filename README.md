# Домашнее задание № 6. Дисковая подсистема. NFS. К курсу Administrator Linux. Professional

- Создали Vagrantfile. `vagrant up` поднимает 2 настроенные виртуальные машины: __nfss__ сервер NFS и __nfsc__ клиент.

## Настройка сервера NFS

- заходим на сервер

```bash
vagrant ssh nfss 
```

- Установка утилит

```bash
yum install nfs-utils
```

- Включить firewall

```bash
systemctl enable firewalld --now
```

- разрешить в firewall доступ к сервисам NFS

```bash
firewall-cmd --add-service="nfs3" \
--add-service="rpc-bind" \
--add-service="mountd" \
--permanent

firewall-cmd --reload
```

- включить сервер NFS

```bash
systemctl enable nfs --now 
```

- создать и настроить директорию, которая будет экспортирована в будущем

```bash
mkdir -p /srv/share/upload
chown -R nfsnobody:nfsnobody /srv/share
chmod 0777 /srv/share/upload
```

- создать в файле __/etc/exports__ структуру, которая позволит экспортировать ранее созданную директорию

```bash
cat << EOF > /etc/exports
/srv/share 10.111.177.160/32(rw,sync,root_squash)
EOF
```

- экспортировать ранее созданную директорию

```bash
exportfs -r
```

- проверить экспортированную директорию следующей командой

```bash
exportfs -s
```

- Вывод должен быть аналогичен этому:

```bash
[root@nfss ~]# exportfs -s
/srv/share 10.111.177.160/32(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,root_squash,no_all_squash)
```

## Настройка клиент NFS

- зайти на клиент

```bash
vagrant ssh nfsc
```

- доустановить вспомогательные утилиты

```bash
yum install nfs-utils
```

- включить firewall

```bash
systemctl enable firewalld --now
systemctl status firewalld
```

- добавить в __/etc/fstab__ строку:

```bash
echo "10.111.177.150:/srv/share/ /mnt nfs vers=3,proto=udp,noauto,x-systemd.automount 0 0" >> /etc/fstab
#mount /mnt # монтируется автоматически при обращении
```

- Выполнить

```bash
systemctl daemon-reload
systemctl restart remote-fs.target

mount | grep mnt
```

-Проверка состояния

```bash
mount | grep mnt 
systemd-1 on /mnt type autofs  
(rw,relatime,fd=46,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pip e_ino=26801) 
10.111.177.150:/srv/share/ on /mnt type nfs  
(rw,relatime,vers=3,rsize=32768,wsize=32768,namlen=255,hard,proto=ud p,timeo=11,retrans=3,sec=sys,mountaddr=10.111.177.150,mountvers=3,mou ntport=20048,mountproto=udp,local_lock=none,addr=10.111.177.150)
``` 

- На клиенте создать файл в расшаренной директории:

```bash
touch /mnt/upload/testfile
```

- Проверить наличие созданного файла на сервере:

```bash
$ ls -la /srv/share/upload/
total 0
drwxrwxrwx. 2 nfsnobody nfsnobody 18 Dec  9 13:38 .
drwxr-xr-x. 3 nfsnobody nfsnobody 32 Dec  9 13:37 ..
-rw-rw-r--. 1 vagrant   vagrant    0 Dec  9 13:38 test
```

## Добавить возможность конфигурирования сервера и клиента используя provision (bash script)

- Разместил скрипт конфигурирования сервера ./scripts/nfss\_script.sh

- Разместил скрипт конфигурирования клиента ./scripts/nfsc\_script.sh

- Уничтожил тестовый стенд и поднял снова:

```bash
vagrant destory  -f
vagrant up
```

- Повторил проверку состояния. Работает.


## Заметки

- При монтировании nfs-шары в ОС Windows имена файлов с кириллическими символами сохраняются в кодировке CP-1251, при необходимости 

