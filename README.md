# Setup new Ubuntu server

1. installer diskをつかってシステムをインストール(USB driveを認識させるためにBIOSの設定が必要かも)
2. 再起動後、再度BIOSで起動ディスクをhddに設定。
3. 起動したら、installerで作成した管理者アカウントでログイン。
4. 次のコマンドでsysconfを入手。
  ```shell
  git clone https://github.com/tetrahdroid/sys.conf.git
  cd sysconf
  ```
5. Makefileの先頭行に書いてある項目を順番にsudoでmakeする。
  ```
  sudo make nis
  ```
6. GPUが搭載されている場合は、CUDAをインストールする。
  ```
  sudo make extra
  ```

以上。
