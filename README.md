# teckel
Simple leaderboard middleware

## Usage:
  - have an Erlang install working, e.g. 18.3
  - have Redis running on port 6379 (default)
  - `erl -pa ./ebin ./deps/*/ebin` so Erlang can see the application and deps
  - `application:ensure_all_started(teckel).`

Example:
```
curl localhost:8080
Hello Erlang!

curl -X POST -H 'Content-Type: application/json' -d '{"score": 1337}' localhost:8080/user/kyle/score
{"ok": true}

curl localhost:8080/user/kyle/score
{"score": 1337}
```

TODO:
 - accept GET /leaderboard and return top 10 scores
 - Ansible playbook to provision deploy teckel and redis
 - POC using rockfall
 - Blog post
