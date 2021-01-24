```
Eshell V11.1.4  (abort with ^G)
1> {ok, Server} = resource_server:start_link().
{ok,<0.80.0>}
2> resource_server:acquire(Server, 500, 5).
Available resource:1000
The rest:500
{acquire_success,#Ref<0.3759256383.599523334.257332>}
3> Timeout_release, the rest:1000
3> {_,Ref} = resource_server:acquire(Server, 500, 999).
Available resource:1000
The rest:500
{acquire_success,#Ref<0.3759256383.599523334.257344>}
4> resource_server:acquire(Server, 1000, 999).
fail
5> resource_server:release(Server, Ref).
The rest:1000
ok
6> resource_server:shutdown(Server).
Server was terminated.normal
ok
7> 
```

