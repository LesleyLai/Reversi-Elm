See the [demo](https://lesleylai.github.io/Reversi-Elm/) here.

## Installing Elm packages

```sh
elm-app install <package-name>
```

Other `elm-package` commands are also [available.](#package)

## Available scripts
In the project directory you can run:
### `elm-app build`
Builds the app for production to the `build` folder.  

The build is minified, and the filenames include the hashes.  
Your app is ready to be deployed!

### `elm-app start`
Runs the app in the development mode.  
Open [http://localhost:3000](http://localhost:3000) to view it in the browser.

The page will reload if you make edits.  
You will also see any lint errors in the console.

### `elm-app install`

An alias for [`elm-app package install`](#package)

### `elm-app test`
Run tests with [node-test-runner](https://github.com/rtfeldman/node-test-runner/tree/master)

You can make test runner watch project files by running:
```sh
elm-app test --watch
```

### `elm-app eject`

**Note: this is a one-way operation. Once you `eject`, you can’t go back!**

If you aren’t satisfied with the build tool and configuration choices, you can `eject` at any time.

Instead, it will copy all the configuration files and the transitive dependencies (Webpack, Elm Platform, etc.) right into your project, so you have full control over them. All of the commands except `eject` will still work, but they will point to the copied scripts so you can tweak them. At this point, you’re on your own.

You don’t have to use 'eject' The curated feature set is suitable for small and middle deployments, and you shouldn’t feel obligated to use this feature. However, we understand that this tool wouldn’t be useful if you couldn’t customize it when you are ready for it.

### `elm-app <elm-platform-comand>`

Create Elm App does not rely on the global installation of Elm Platform, but you still can use its local Elm Platform to access default command line tools:

#### `package`

Alias for [elm-package](http://guide.elm-lang.org/get_started.html#elm-package)

Use it for installing Elm packages from [package.elm-lang.org](http://package.elm-lang.org/)

#### `repl`

Alias for [elm-repl](http://guide.elm-lang.org/get_started.html#elm-repl)

#### `make`

Alias for  [elm-make](http://guide.elm-lang.org/get_started.html#elm-make)

#### `reactor`

Alias for  [elm-reactor](http://guide.elm-lang.org/get_started.html#elm-reactor)


## Turning on/off Elm Debugger

By default, in production (`elm-app build`) the Debugger is turned off and in development mode (`elm-app start`) it's turned on.

To turn on/off Elm Debugger explicitly, set `ELM_DEBUGGER` environment variable to `true` or `false` respectively.

## Dead code elimination

Create Elm App comes with an opinionated setup for dead code elimination which is disabled by default, because it may break your code.

You can enable it by setting `DEAD_CODE_ELIMINATION` environment variable to `true`

## Changing the base path of the assets in the HTML

By default, assets will be linked from the HTML to the root url. For example `/css/style.css`.

If you deploy to a path that is not the root, you can change the `PUBLIC_URL` environment variable to properly reference your assets in the compiled assets. For example: `PUBLIC_URL=./ elm-app build`.

## Changing the Page `<title>`

You can find the source HTML file in the `public` folder of the generated project. You may edit the `<title>` tag in it to change the title from “Elm App” to anything else.

Note that normally you wouldn’t edit files in the `public` folder very often. For example, [adding a stylesheet](#adding-a-stylesheet) is done without touching the HTML.

If you need to dynamically update the page title based on the content, you can use the browser [`document.title`](https://developer.mozilla.org/en-US/docs/Web/API/Document/title) API and [ports.](https://guide.elm-lang.org/interop/javascript.html#ports)

## Adding a Stylesheet

This project setup uses [Webpack](https://webpack.js.org/) for handling all assets. Webpack offers a custom way of “extending” the concept of `import` beyond JavaScript. To express that a JavaScript file depends on a CSS file, you need to **import the CSS from the JavaScript file**:

### `main.css`

```css
body {
  padding: 20px;
}
```

### `index.js`

```js
import './main.css'; // Tell Webpack to pick-up the styles from main.css
```

## Post-Processing CSS

This project setup minifies your CSS and adds vendor prefixes to it automatically through [Autoprefixer](https://github.com/postcss/autoprefixer) so you don’t need to worry about it.

For example, this:

```css
.container {
  display: flex;
  flex-direction: row;
  align-items: center;
}
```

becomes this:

```css
.container {
  display: -webkit-box;
  display: -ms-flexbox;
  display: flex;
}
```

In development, expressing dependencies this way allows your styles to be reloaded on the fly as you edit them. In production, all CSS files will be concatenated into a single minified `.css` file in the build output.

You can put all your CSS right into `src/main.css`. It would still be imported from `src/index.js`, but you could always remove that import if you later migrate to a different build tool.

## Using elm-css

### Step 1: Install [elm-css](https://github.com/rtfeldman/elm-css) npm package

```sh
npm install elm-css -g
```

### Step 2: Install Elm dependencies

```sh
elm-app install rtfeldman/elm-css
elm-app install rtfeldman/elm-css-helpers
```

### Step 3: Create the stylesheet file

Create an Elm file at `src/Stylesheets.elm` (The name of this file cannot be changed).

```elm
port module Stylesheets exposing (main, CssClasses(..), CssIds(..), helpers)

import Css exposing (..)
import Css.Elements exposing (body, li)
import Css.Namespace exposing (namespace)
import Css.File exposing (..)
import Html.CssHelpers exposing (withNamespace)


port files : CssFileStructure -> Cmd msg


cssFiles : CssFileStructure
cssFiles =
    toFileStructure [ ( "src/style.css", Css.File.compile [ css ] ) ]


main : CssCompilerProgram
main =
    Css.File.compiler files cssFiles


type CssClasses
    = NavBar


type CssIds
    = Page


appNamespace =
    "App"


helpers =
    withNamespace appNamespace


css =
    (stylesheet << namespace appNamespace)
    [ body
        [ overflowX auto
        , minWidth (px 1280)
        ]
    , id Page
        [ backgroundColor (rgb 200 128 64)
        , color (hex "CCFFFF")
        , width (pct 100)
        , height (pct 100)
        , boxSizing borderBox
        , padding (px 8)
        , margin zero
        ]
    , class NavBar
        [ margin zero
        , padding zero
        , children
            [ li
                [ (display inlineBlock) |> important
                , color primaryAccentColor
                ]
            ]
        ]
    ]


primaryAccentColor =
    hex "ccffaa"
```

### Steap 4: Compiling the stylesheet

To compile the CSS file, just run

```sh
elm-css src/Stylesheets.elm
```

This will generate a file called `style.css`

### Step 5: Import the compiled CSS file

Add the following line to your `src/index.js`:

```js
import './style.css';
```

### Step 6: Using the stylesheet in your Elm code

```elm
import Stylesheets exposing (helpers, CssIds(..), CssClasses(..))


view model =
    div [ helpers.id Page ]
        [ div [ helpers.class [ NavBar ] ]
            [ text "Your Elm App is working!" ]
        ]
```

Please note that `Stylesheets.elm` exposes `helpers` record, which contains functions for creating id and class attributes.

You can also destructure `helpers` to make your view more readable:

```elm
{ id, class } =
    helpers
```

## Adding Images and Fonts

With Webpack, using static assets like images and fonts works similarly to CSS.

By requiring an image in JavaScript code, you tell Webpack to add a file to the build of your application. The variable will contain a unique path to the said file.

Here is an example:

```js
import logoPath from './logo.svg'; // Tell Webpack this JS file uses this image
import { Main } from './Main.elm';

Main.embed(
    document.getElementById('root'),
    logoPath // Pass image path as a flag for Html.programWithFlags
  );
```

Later on, you can use the image path in your view for displaying it in the DOM.

```elm
view : Model -> Html Msg
view model =
    div []
        [ img [ src model.logo ] []
        , div [] [ text model.message ]
        ]
```

## Using the `public` Folder

### Changing the HTML

The `public` folder contains the HTML file so you can tweak it, for example, to [set the page title](#changing-the-page-title).
The `<script>` tag with the compiled code will be added to it automatically during the build process.

### Adding Assets Outside of the Module System

You can also add other assets to the `public` folder.

Note that we normally encourage you to `import` assets in JavaScript files instead.
For example, see the sections on [adding a stylesheet](#adding-a-stylesheet) and [adding images and fonts](#adding-images-fonts-and-files).
This mechanism provides a few benefits:

* Scripts and stylesheets get minified and bundled together to avoid extra network requests.
* Missing files cause compilation errors instead of 404 errors for your users.
* Result filenames include content hashes, so you don’t need to worry about browsers caching their old versions.

However, there is a **escape hatch** that you can use to add an asset outside of the module system.

If you put a file into the `public` folder, it will **not** be processed by Webpack. Instead, it will be copied into the build folder untouched.   To reference assets in the `public` folder, you need to use a special variable called `PUBLIC_URL`.

Inside `index.html`, you can use it like this:

```html
<link rel="shortcut icon" href="%PUBLIC_URL%/favicon.ico">
```

Only files inside the `public` folder will be accessible by `%PUBLIC_URL%` prefix. If you need to use a file from `src` or `node_modules`, you’ll have to copy it there to explicitly specify your intention to make this file a part of the build.

When you run `elm-app build`, Create Elm App will substitute `%PUBLIC_URL%` with a correct absolute path, so your project works even if you use client-side routing or host it at a non-root URL.

In Elm code, you can use `%PUBLIC_URL%` for similar purposes:

```elm
// Note: this is an escape hatch and should be used sparingly!
// Normally we recommend using `import`  and `Html.programWithFlags` for getting 
// asset URLs as described in “Adding Images and Fonts” above this section.
img [ src "%PUBLIC_URL%/logo.svg" ] []
```

In JavaScript code, you can use `process.env.PUBLIC_URL` for similar purposes:

```js
const logo = `<img src=${process.env.PUBLIC_URL + '/img/logo.svg'} />`;
```

Keep in mind the downsides of this approach:

* None of the files in `public` folder get post-processed or minified.
* Missing files will not be called at compilation time, and will cause 404 errors for your users.
* Result filenames won’t include content hashes so you’ll need to add query arguments or rename them every time they change.

### When to Use the `public` Folder

Normally we recommend importing [stylesheets](#adding-a-stylesheet), [images, and fonts](#adding-images-fonts-and-files) from JavaScript.
The `public` folder is used as a workaround for some less common cases:

* You need a file with a specific name in the build output, such as [`manifest.webmanifest`](https://developer.mozilla.org/en-US/docs/Web/Manifest).
* You have thousands of images and need to dynamically reference their paths.
* You want to include a small script like [`pace.js`](http://github.hubspot.com/pace/docs/welcome/) outside of the bundled code.
* Some library may be incompatible with Webpack and you have no other option but to include it as a `<script>` tag.

Note that if you add a `<script>` that declares global variables, you also need to read the next section on using them.


## Using custom environment variables

In your JavaScript code you have access to variables declared in your
environment, like an API key set in an `.env`-file or via your shell. They are
available on the `process.env`-object and will be injected during build time.

Besides the `NODE_ENV` variable you can access all variables prefixed with
`ELM_APP_`:

```bash
# .env
ELM_APP_API_KEY="secret-key"
```

Alternatively, you can set them on your shell before calling the start- or
build-script, e.g.:

```bash
ELM_APP_API_KEY="secret-key" elm-app start
```

Both ways can be mixed, but variables set on your shell prior to calling one of
the scripts will take precedence over those declared in an `.env`-file.

Passing the variables to your Elm-code can be done via `flags`:

```javascript
// index.js
import { Main } from './Main.elm';

Main.fullscreen({
  environment: process.env.NODE_ENV,
  apiKey: process.env.ELM_APP_API_KEY,
});
```

```elm
-- Main.elm
type alias Flags = { apiKey : String, environment : String }

init : Flags -> ( Model, Cmd Msg )
init flags =
  ...

main =
  programWithFlags { init = init, ... }
```

Be aware that you cannot override `NODE_ENV` manually. See
[this list from the `dotenv`-library](https://github.com/bkeepers/dotenv#what-other-env-files-can-i-use)
for a list of files you can use to declare environment variables.


## Setting up API Proxy
To forward the API ( REST ) calls to backend server, add a proxy to the `elm-package.json` in the top level json object.

```json
{
    ...
    "proxy" : "http://localhost:1313",
    ...
}
```

Make sure the XHR requests set the `Content-type: application/json` and `Accept: application/json`.
The development server has heuristics, to handle its own flow, which may interfere with proxying of 
other html and javascript content types.

```sh
 curl -X GET -H "Content-type: application/json" -H "Accept: application/json"  http://localhost:3000/api/list
```

## Running Tests

Create Elm App uses [elm-test](https://github.com/rtfeldman/node-test-runner) as its test runner.

### Dependencies in Tests

To use packages in tests, you also need to install them in `tests` directory.

```bash
elm-app test --add-dependencies elm-package.json 
```

### Continuous Integration

#### Travis CI

1. Following the [Travis Getting started](https://docs.travis-ci.com/user/getting-started/) guide for syncing your GitHub repository with Travis.  You may need to initialize some settings manually in your [profile](https://travis-ci.org/profile) page.
1. Add a `.travis.yml` file to your git repository.

```yaml
language: node_js

sudo: required

node_js:
  - '7'

install:
  - npm i create-elm-app -g

script: elm-app test
```

1. Trigger your first build with a git push.
1. [Customize your Travis CI Build](https://docs.travis-ci.com/user/customizing-the-build/) if needed.

## Deployment


`elm-app build` creates a `build` directory with a production build of your app. Set up your favourite HTTP server so that a visitor to your site is served `index.html`, and requests to static paths like `/static/js/main.<hash>.js` are served with the contents of the `/static/js/main.<hash>.js` file.
```

### GitHub Pages

#### Step 1: Add `homepage` to `elm-package.json`

**The step below is important!**<br>
**If you skip it, your app will not deploy correctly.**

Open your `elm-package.json` and add a `homepage` field:

```js
  "homepage": "https://myusername.github.io/my-app",
```

Create Elm App uses the `homepage` field to determine the root URL in the built HTML file.

#### Step 2: Build the static site

```sh
elm-app build
```

#### Step 3: Deploy the site by running `gh-pages -d build`

We will use [gh-pages](https://www.npmjs.com/package/gh-pages) to upload the files from the `build` directory to GitHub. If you haven't already installed it, do so now (`npm install -g gh-pages`)

Now run:

```sh
gh-pages -d build
```

#### Step 4: Ensure your project’s settings use `gh-pages`

Finally, make sure **GitHub Pages** option in your GitHub project settings is set to use the `gh-pages` branch:

<img src="http://i.imgur.com/HUjEr9l.png" width="500" alt="gh-pages branch setting">

#### Step 5: Optionally, configure the domain

You can configure a custom domain with GitHub Pages by adding a `CNAME` file to the `public/` folder.

#### Notes on client-side routing

GitHub Pages doesn’t support routers that use the HTML5 `pushState` history API under the hood (for example, React Router using `browserHistory`). This is because when there is a fresh page load for a url like `http://user.github.io/todomvc/todos/42`, where `/todos/42` is a frontend route, the GitHub Pages server returns 404 because it knows nothing of `/todos/42`. If you want to add a router to a project hosted on GitHub Pages, here are a couple of solutions:

* You could switch from using HTML5 history API to routing with hashes.
* Alternatively, you can use a trick to teach GitHub Pages to handle 404 by redirecting to your `index.html` page with a special redirect parameter. You would need to add a `404.html` file with the redirection code to the `build` folder before deploying your project, and you’ll need to add code handling the redirect parameter to `index.html`. You can find a detailed explanation of this technique [in this guide](https://github.com/rafrex/spa-github-pages).

## IDE setup for Hot Module Replacement

Remember to disable [safe write](https://webpack.github.io/docs/webpack-dev-server.html#working-with-editors-ides-supporting-safe-write) if you are using VIM or IntelliJ IDE, such as WebStorm.
