# Redirector
Redirector is a safari extension which allow redirect and block any http request by custom rules.

**[Download extension package](http://lanceli.github.io/redirector/redirector-latest.safariextz)**


For chrome, check out [Switcheroo Redirector](https://chrome.google.com/webstore/detail/switcheroo-redirector/cnmciclhnghalnpfhhleggldniplelbg)

## Rules Examples
### Redirect request

```
from_url,to_url
fonts.googleapis.com,fonts.useso.com
ajax.googleapis.com,ajax.useso.com
```

### Block Request
```
block_url
fonts.googleapis.com
googleapis.*\/.js
```

if you want disable any rule, just add comma in end of rule,
rule will disable when it contain more than one comma.

```
from_url,to_url,
block_url,,
```

## Usage for developer
For develop you need  _Git_ and _Node.js_:

```
$ git clone git://github.com/lanceli/redirector.git
$ cd redirector
$ npm install
$ grunt debug
```
For release:

```
$ grunt
```

## Release History
See the [CHANGELOG](CHANGELOG).

## Contributors
Author: [Lance Li](http://github.com/lanceli)

## License
Licensed under the MIT License.
