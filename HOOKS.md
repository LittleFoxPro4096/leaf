- 重新加载`Systemd`服务

    软件: [sys-apps/systemd](https://github.com/systemd/systemd)

    文件:
    `/usr/lib/systemd/system/.*`

    操作:
    ```sh
    /usr/bin/systemctl daemon-reload
    ```

---

- 更新`info`文档数据库

    软件: [sys-apps/texinfo](https://www.gnu.org/software/texinfo)

    文件:
    `/usr/share/info/.*\.info.*`

    操作: 
    ```sh
    rm -fv /usr/share/info/dir
    for _info in /usr/share/info/*.info*; do
      /usr/bin/install-info $_info /usr/share/info/dir
    done
    ```

---

- 更改`Polkit`规则文件组属性

    软件: [sys-auth/polkit](https://gitlab.freedesktop.org/polkit/polkit)

    文件:
    `/etc/polkit-1/rules.d/.*\.rules`
    `/usr/share/polkit-1/rules\.d/.*\.rules`

    操作: 
    ```sh
    install -dm750 -g polkitd /{etc,usr/share}/polkit-1/rules.d
    ```

---

- 更新`desktop`图标数据库

    软件: [dev-utils/desktop-file-utils](https://www.freedesktop.org/wiki/Software/desktop-file-utils)

    文件:
    `/usr/share/applications/.*\.desktop`

    操作: 
    ```sh
    /usr/bin/update-desktop-database -q /usr/share/applications
    ```

---

- 更新`MIME`类型数据库

    软件: [x11-misc/shared-mime-info](https://gitlab.freedesktop.org/xdg/shared-mime-info)

    文件:
    `/usr/share/mime/packages/.*\.xml`

    操作:
    ```sh
    /usr/bin/update-mime-database /usr/share/mime
    ```

---

- 更新字体配置缓存

    软件: [media-libs/fontconfig](https://www.freedesktop.org/wiki/Software/fontconfig)

    文件:
    `/etc/fonts/conf.d/.*`
    `/usr/share/fonts/.*`
    `/usr/share/fontconfig/conf\.avail/.*`
    `/usr/share/fontconfig/conf\.default/.*`

    操作:
    ```sh
    /usr/bin/fc-cache -s
    ```

---

- 更新`GIO`模块缓存

    软件: [dev-libs/glib](https://gitlab.gnome.org/GNOME/glib)

    文件:
    `/usr/lib/gio/modules/.*\.so`

    操作:
    ```sh
    /usr/bin/gio-querymodules /usr/lib/gio/modules
    ```

---

- 编译`GSettings XML`模式文件

    软件: [dev-libs/glib](https://gitlab.gnome.org/GNOME/glib)

    文件:
    `/usr/share/glib-2\.0/schemas/.*\.gschema\.xml`
    `/usr/share/glib-2\.0/schemas/.*\.gschema\.override`

    操作:
    ```sh
    /usr/bin/glib-compile-schemas /usr/share/glib-2.0/schemas
    ```

---

- 探测`GDK-Pixbuf`加载器模块

    软件: [x11-libs/gdk-pixbuf](https://gitlab.gnome.org/GNOME/gdk-pixbuf)

    文件:
    `/usr/lib/gdk-pixbuf-2\.0/2\.10\.0/loaders/.*\.so`

    操作:
    ```sh
    /usr/bin/gdk-pixbuf-query-loaders --update-cache
    ```

---

- 探测`GTK+2`模块

    软件: [x11-libs/gtk+-2](https://gitlab.gnome.org/GNOME/gtk)

    文件:
    `/usr/lib/gtk-2\.0/2\.10\.0/immodules/.*\.so`

    操作:
    ```sh
    /usr/bin/gtk-query-immodules-2.0 --update-cache
    ```

---

- 探测`GTK+3`模块

    软件: [x11-libs/gtk+-3](https://gitlab.gnome.org/GNOME/gtk)

    文件:
    `/usr/lib/gtk-3\.0/3\.0\.0/immodules/.*\.so`

    操作:
    ```sh
    /usr/bin/gtk-query-immodules-3.0 --update-cache
    ```

---

- 更新`GTK`图标主题

    软件: [x11-libs/gtk+](https://gitlab.gnome.org/GNOME/gtk)

    文件:
    `/usr/share/icons/.*`

    操作:
    ```sh
    /usr/bin/gtk-update-icon-cache -q /usr/share/icons/*
    ```
