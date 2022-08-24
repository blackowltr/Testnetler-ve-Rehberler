## RPC-GRPC Nasıl Öğreniriz?

**Gaia RPC**
```
echo "$(curl -s ifconfig.me)$(grep -A 3 "\[rpc\]" ~/.gaia/config/config.toml | egrep -o ":[0-9]+")"
```

**Gaia GRPC**
```
echo "$(curl -s ifconfig.me)$(grep -A 6 "\[grpc\]" ~/.gaia/config/app.toml | egrep -o ":[0-9]+")"
```

**Stride RPC**
```
echo "$(curl -s ifconfig.me)$(grep -A 3 "\[rpc\]" ~/.stride/config/config.toml | egrep -o ":[0-9]+")"
```

**Stride GRPC**
```
echo "$(curl -s ifconfig.me)$(grep -A 6 "\[grpc\]" ~/.stride/config/app.toml | egrep -o ":[0-9]+")"
```

### Kolay Gelsin..
