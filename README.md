# podpatch

A simple command line tool to modify a Podfile without having to open a text editor

## How to install

```bash
▶ ./install.sh
```

## How to use

- It supports only the properties `branch` and `path`
- It has to be run in the same folder as the Podfile that would be modified
- The command will find the line in the Podile that defines how to get that pod and update it with the property specified
- Only one property can be specified per command


Modify `branch` 

```bash
▶ podpatch <pod_name> branch:<branch_name>
```

Modify `path`:

```bash
▶ podpatch <pod_name> path:<pod_folder>
```



