import json
import os
import discordv as vd
import net.http

struct HastebinResponse {
    key string
}

struct JokeResponse {
    joke string
}

const (
    prefix = '!'
)

fn main() {

	token := os.getenv('BOT_TOKEN')
    println(token)
    if token == '' {
        println('Please provide a valid bot token using BOT_TOKEN environment variable')
        return
    }

    mut client := vd.new(token: token, intents: 515) ?
    client.on_message_create(on_message_create)
    client.open() ?

}

fn on_message_create(mut client vd.Client, evt &vd.MessageCreate) {

    if evt.attachments.len == 1 {
        attachment := evt.attachments[0]
        if attachment.filename == 'message.txt' {
            file_content := http.get(attachment.url) or {
                client.channel_message_send(evt.channel_id, 'File content unreachable :confused:')
                return
            }
            haste_res := http.post('https://hastebin.androz2091.fr/documents', file_content.text) or {
                client.channel_message_send(evt.channel_id, 'Hastebin server unreachable :confused:')
                return
            }
            haste_res_json := json.decode(HastebinResponse, haste_res.text) or {
                client.channel_message_send(evt.channel_id, 'Hastebin server sent wrong response :confused:')
                return
            }
            haste_key := haste_res_json.key
            client.channel_message_delete(evt.channel_id, evt.id)
            client.channel_message_send(evt.channel_id, '<@$evt.author.id>\'s file has been posted on hastebin! https://hastebin.androz2091.fr/$haste_key')
        }
    }

    if !evt.content.starts_with(prefix) {
        return
    }

    mut arguments := evt.content.substr(1, evt.content.len).split(' ')
    cmd_name := arguments[0]
    arguments = arguments[1..arguments.len]

    if cmd_name == 'ask' {
        client.channel_message_delete(evt.channel_id, evt.id)
        client.channel_message_send(evt.channel_id, 'https://dontasktoask.com/ :wink:')
    }

    if cmd_name == 'lmg' {
        search := arguments.join(' ')
        if search == '' {
            client.channel_message_send(evt.channel_id, 'Please enter a search!')
            return
        }
        search_formatted := search.split(' ').join('%20')
        client.channel_message_send(evt.channel_id, '<https://lmgtfy.com/?q=$search_formatted>')
    }

    if cmd_name == 'joke' {
        joke_res := http.get('https://geek-jokes.sameerkumar.website/api?format=json') or {
            client.channel_message_send(evt.channel_id, 'API unreachable :confused:')
            return
        }
        joke_res_json := json.decode(JokeResponse, joke_res.text) or {
            client.channel_message_send(evt.channel_id, 'API sent wrong response :confused:')
            return
        }
        joke_content := joke_res_json.joke
        client.channel_message_send(evt.channel_id, '<@$evt.author.id> | $joke_content')
    }

    if cmd_name == 'mention' {
        client.channel_message_delete(evt.channel_id, evt.id)
        client.channel_message_send(evt.channel_id, 'Please do not ping people to get help. Ask your question and if the person is available, he or she will answer you (and if someone else knows, he or she will answer too). :wink:')
    }

    if cmd_name == '!ping' {
        client.channel_message_send(evt.channel_id, 'pong!')
    }

}
