# Alien RFID Web App

[![CodeClimate](http://img.shields.io/codeclimate/github/arturhoo/alien-webapp.svg)](https://codeclimate.com/github/arturhoo/alien-webapp)
[![Gemnasium](http://img.shields.io/gemnasium/arturhoo/alien-webapp.svg)](https://gemnasium.com/arturhoo/alien-webapp)


## Components

**Sinatra Application**

Responsible for:

- Retrieving information from the reader;
- Receiving post messages from the reader;
- Serving the web app.

The Sinatra app runs on port 5000.

**Faye Server**

Responsible for creating a pub/sub messaging channel between the backend server (Sinatra) and the webapp. It is set to run on port 9000.

## Running

Install the necessary gems running `bundle install`.

Create a `config.yml` file that specifies both the Reader address and the host address:

```yaml
reader_addr: '10.0.0.21'
app_addr: '10.0.0.22'
```

Run both Sinatra and Faye using foreman

```bash
$ bundle exec foreman start
```

Visit `http://localhost:5000` on your browser.

## How it works

**Manual mode**

1. The user presses the button that manually requests the tags on the reader. The webapp send a GET request to Sinatra's path 'tags.json';
2. Sinatra receives the GET request and synchronously connects to the Reader and fetches the taglist. The taglist is parsed and JSON-formatted;
3. The webapp receives the JSON and displays the tags in the webpage.

**Auto mode**

1. The user presses the button that enables automode. The webapp sends a POST request to Sinatra's path `/auto`;
2. Sinatra schedules a background job (so that the webapp and user don't hang on waiting) that enables auto and notify modes on the reader. During this phase, the reader is configured to send notification messages to the Sinatra app;
3. At the same time, the webapp, through faye, subscribes to the `alien` channel;
4. The auto and notify modes stay enabled for a short amount of time. During this time, when tags are recognized by the reader, they are sent to the Sinatra app. Whe the sinatra app receives a message, it forwards it to Faye's channel `alien`;
5. As the webapp is subscribed to the `alien` channel, a Javascript function display the original reader's message into the webpage.
