
![Logo](https://cdn.errorism.cc/errorism_scripts_banner.png)


## Authors

- [@Errorismx](https://www.github.com/Errorismx)


# Time Utils

just a simple script that store onlinetime and custom time that you want easier.


## Features

- Online Time Tracker
- Exports for easy access

## Requirement

- [es_extended](https://github.com/esx-framework/esx_core)
- [oxmysql](https://github.com/overextended/oxmysql)
- [esx_datastore](https://github.com/esx-framework/esx_datastore)

## API Reference [Serverside]

#### Get time record without plus from database (airtime).
```lua
exports['errorism.time']:getCurrent(index,identifier)
```
| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `index` | `string` | **Required**. Index of time record |
| `identifier` | `string` | **Required**. Identifier of player |

#### Get time record.

```lua
exports['errorism.time']:get(index,identifier,onDatabase)
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `index` | `string` | **Required**. Index of time record |
| `identifier` | `string` | **Required**. Identifier of player |
| `onDatabase` | `boolean` | Plus time from database |

#### Start custom time record.

```lua
exports['errorism.time']:start(index,identifier)
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `index` | `string` | **Required**. Index of time record |
| `identifier`| `string` | **Required**. Identifier of player |

#### Stop custom time record and return the result.

```lua
exports['errorism.time']:stop(index,identifier,save)
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `index` | `string` | **Required**. Index of time record |
| `identifier`| `string` | **Required**. Identifier of player |
| `save`| `boolean` | Save on database? |
| `return`| `int` | Time result in milliseconds (airtime if not save) |
## Usage/Examples

```lua
local xPlayer = ESX.GetPlayerFromId(source)
local identifier = xPlayer.getIdentifier()
local onlineTime = exports['errorism.time']:get('online',identifier,true)
print(onlineTime)
-- Output : 123123
exports['errorism.time']:start('test',identifier)
Wait(3000)
local time = exports['errorism.time']:stop('test',identifier,true)
print(time)
-- Output : 3000
```


## Tech Stack

**Server:** lua

