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

fn main() {

	token := os.getenv('BOT_TOKEN')
    println(token)
    if token == '' {
        println('Please provide a valid bot token using BOT_TOKEN environment variable')
        return
    }

    mut client := vd.new(token: token, intents: 515) ?
    client.on_message_create(on_message_create)
    client.on_guild_member_add(on_guild_member_add)
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

    if evt.content == '!ask' {
        client.channel_message_delete(evt.channel_id, evt.id)
        client.channel_message_send(evt.channel_id, 'https://dontasktoask.com/ :wink:')
    }

    if evt.content.starts_with('!lmg') {
        search := evt.content.substr(5, evt.content.len)
        if search == '' {
            client.channel_message_send(evt.channel_id, 'Please enter a search!')
            return
        }
        search_formatted := search.split(' ').join('%20')
        client.channel_message_send(evt.channel_id, '<https://lmgtfy.com/?q=$search_formatted>')
    }

    if evt.content == '!joke' {
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

    if evt.content == '!ping' {
        client.channel_message_send(evt.channel_id, 'pong!') or { }
    }

}
