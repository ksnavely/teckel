# teckel
Simple leaderboard middleware

## Usage:
  - have an Erlang install working, e.g. 18.3
  - have Redis running on port 6379 (default)

```
# Build the release
make

# Start the server
make run

# In another window
$> curl localhost:8080
{"hello": "teckel!"}

$> curl -X POST -H 'Content-Type: application/json' -d '{"score": 1337}' localhost:8080/user/kyle/score
{"ok": true}

$> curl -X POST -H 'Content-Type: application/json' -d '{"score": 999999999}' localhost:8080/user/emily/score
{"ok": true}

$> curl localhost:8080/user/kyle/score
{"score": 1337}

$> curl localhost:8080/user/emily/score
{"score": 999999999}

$> curl localhost:8080/top_scores
{"top_scores": {"emily":"999999999","kyle":"1337"}}
```

TODO:
 - POC using rockfall
