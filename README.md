# Imp Environment Tail

Displays the current temperature (and humidity and pressure) as read by the
"Environment Tail" attached to an imp001.

## impCentral API Integration

```sh
imp_user=...
imp_password=...
impt auth login --user "$imp_user" --pwd "$imp_password"
# ^^ passing passwords on the command-line isn't particularly secure (they're visible in `ps`)

device_group=...
impt project link --device-file device.nut_ --agent-file agent.nut_ --dg "$device_group"
```
