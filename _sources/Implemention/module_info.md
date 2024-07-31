# 模块信息
## `./` 根目录文件

```bash
├── environment.yml             # python环境配置文件
└──  README.md                  # 项目README文件
```


## `utils` 包

### `file` 模块

<a id="file"></a>
````{card} Information
`utils.file` module
^^^
Created on : 2024-07-02 

Created by : Mythezone

Updated by : Mythezone

Email      : mythezone@gmail.com

FileName   : utils/file.py

Description: Generic Utility Functions
+++
Updated    : 

Todo       :
````

---
(create_or_pass)=
#### `create_or_pass` 方法

```python
def create_or_pass(file_path, debug=False) -> bool
```

**Summary**:
* Check if the file path exists, or create all the folders needed.

**Arguments**:

- `file_path` _str_ - The file path.Required.
  

**Returns**:

- `bool` - if the path exists or created return True, else return False.



```{warning}
The file_path should contain the file, like "path/to/file.txt".
```

```{note}
* `create_or_pass` will help you create all the folder on the path recursively.
```
---

### `xmls` 模块
