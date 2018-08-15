/***
Library for interacting with the client state

This module provides client-specific hooks back into the glirc client.
Through this library scripts can send messages, check modes, and more.

@module glirc
@author Eric Mertens
@license ISC
@copyright Eric Mertens 2018
*/

#include <assert.h>

#include <lauxlib.h>

#include "glirc-api.h"
#include "glirc-lib.h"
#include "glirc-marshal.h"

/* luaL_ref returns an int, which is passed through glirc_set_timer */
static_assert(sizeof(int) <= sizeof(intptr_t), "timer callback assumption");

/***
Send an IRC command on a connected network. Message tags are ignored
when sending a message.
@function send_message
@tparam string network Network name
@tparam string command IRC Command
@tparam string ... Command parameters (max 15)
@raise `'too many parameters'` and `'client failure'`
@usage glirc.send_message('mynet', 'PRIVMSG', 'someone', 'Hello, Someone!')
*/
static int glirc_lua_send_message(lua_State *L)
{
        /* This module is careful to leave strings on the stack
         * while it is adding them to the message struct.
         */
        struct glirc_message msg = {{0}};

        msg.network.str = luaL_checklstring(L, 1, &msg.network.len);
        msg.command.str = luaL_checklstring(L, 2, &msg.command.len);

        lua_Integer n = lua_gettop(L) - 2;
        if (n > 15) luaL_error(L, "too many parameters");

        struct glirc_string params[n];
        msg.params   = params;
        msg.params_n = n;

        for (lua_Integer i = 0; i < n; i++) {
                params[i].str = luaL_checklstring(L, i+3, &params[i].len);
        }

        if (glirc_send_message(get_glirc(L), &msg)) {
                luaL_error(L, "client failure");
        }

        return 0;
}

/***
Add a message to a chat window as though it was said by the given user.
@function inject_chat
@tparam string network Network name
@tparam string source Message source
@tparam string target Target message window name
@tparam string message Chat message body
@raise `'client failure'`
@usage
glirc.inject_chat('mynet', 'nick!user@host', '#mychannel', 'An injected message')
glirc.inject_chat('mynet', 'script output', 'somenick', 'Script output text')
*/
static int glirc_lua_inject_chat(lua_State *L) {
        size_t netlen, srclen, tgtlen, msglen;
        const char *net = luaL_checklstring(L, 1, &netlen);
        const char *src = luaL_checklstring(L, 2, &srclen);
        const char *tgt = luaL_checklstring(L, 3, &tgtlen);
        const char *msg = luaL_checklstring(L, 4, &msglen);

        if (glirc_inject_chat(get_glirc(L),
               net, netlen, src, srclen, tgt, tgtlen, msg, msglen)) {
                luaL_error(L, "client failure");
        }
        return 0;
}

/***
Print a message to the client console
@function print
@tparam string message Message to print to console
@usage glirc.print('This shows up on the * window')
*/
static int glirc_lua_print(lua_State *L)
{
        size_t msglen = 0;
        const char *msg = luaL_checklstring(L, 1, &msglen);
        luaL_checktype(L, 2, LUA_TNONE);

        glirc_print(get_glirc(L), NORMAL_MESSAGE, msg, msglen);
        return 0;
}

/***
Print an error message to the client console
@function error
@tparam string message Message to print to console
@usage glirc.error('This shows up on the * window')
*/
static int glirc_lua_error(lua_State *L)
{
        size_t msglen = 0;
        const char *msg = luaL_checklstring(L, 1, &msglen);
        luaL_checktype(L, 2, LUA_TNONE);

        glirc_print(get_glirc(L), ERROR_MESSAGE, msg, msglen);
        return 0;
}

/***
Generate a list of names of connected networks.
@function list_networks
@treturn {string,...} A table of network names
@raise `'client failure'`
@usage glirc.list_networks() --> { 'mynet' }
*/
static int glirc_lua_list_networks(lua_State *L)
{
        luaL_checktype(L, 1, LUA_TNONE);

        char **networks = glirc_list_networks(get_glirc(L));
        if (networks == NULL) { luaL_error(L, "client failure"); }

        import_string_array(L, networks);

        return 1;
}

/***
List the connected channels for a given network
@function list_channels
@tparam string network Network name
@treturn {string,...} A table of channel names
@raise `'no such network'`
@usage glirc.list_channels('mynet') --> { '#somechan', '#friends' }
*/
static int glirc_lua_list_channels(lua_State *L)
{
        size_t network_len;
        const char *network;
        network = luaL_checklstring(L, 1, &network_len);
        luaL_checktype(L, 2, LUA_TNONE);

        char **channels = glirc_list_channels(get_glirc(L), network, network_len);
        if (channels == NULL) { luaL_error(L, "no such network"); }

        import_string_array(L, channels);

        return 1;
}

/***
List the users in a channel
@function list_channel_users
@tparam string network Network name
@tparam string channel Channel name
@treturn {string,...} A table of nicknames
@raise `'no such channel'`
@usage glirc.list_channel_users('mynet', '#somechan') --> { 'chatter', 'quietguy' }
*/
static int glirc_lua_list_channel_users(lua_State *L)
{
        size_t network_len, channel_len;
        const char *network, *channel;
        network = luaL_checklstring(L, 1, &network_len);
        channel = luaL_checklstring(L, 2, &channel_len);
        luaL_checktype(L, 3, LUA_TNONE);

        char **users = glirc_list_channel_users
                        (get_glirc(L), network, network_len,
                                       channel, channel_len);
        if (users == NULL) { luaL_error(L, "no such channel"); }

        import_string_array(L, users);

        return 1;
}

/***
Determine the services account for a given nickname
@function user_account
@tparam string network Network name
@tparam string nick    User nickname
@treturn ?string Account name if known, otherwise `nil`
@usage glirc.user_account('mynet', 'somenick') --> 'anaccount'
*/
static int glirc_lua_user_account(lua_State *L)
{
        size_t netlen = 0, nicklen = 0;
        const char *net = luaL_checklstring(L, 1, &netlen);
        const char *nick = luaL_checklstring(L, 2, &nicklen);
        luaL_checktype(L, 3, LUA_TNONE);

        char *acct = glirc_user_account(get_glirc(L), net, netlen, nick, nicklen);
        lua_pushstring(L, acct);
        glirc_free_string(acct);

        return 1;
}

/***
Return the mode sigils for a user on a channel (e.g. + or @)
@function user_channel_modes
@tparam string network Network name
@tparam string channel Channel name
@tparam string nick User nickname
@treturn ?string Sigils if on channel, `nil` otherwise
@usage glirc.user_channel_modes('mynet', '#somechan', 'an_op') --> '@'
*/
static int glirc_lua_user_channel_modes(lua_State *L)
{
        size_t netlen = 0, chanlen = 0, nicklen = 0;
        const char *net = luaL_checklstring(L, 1, &netlen);
        const char *chan = luaL_checklstring(L, 2, &chanlen);
        const char *nick = luaL_checklstring(L, 3, &nicklen);
        luaL_checktype(L, 4, LUA_TNONE);

        char *sigils = glirc_user_channel_modes(get_glirc(L), net, netlen, chan, chanlen, nick, nicklen);
        lua_pushstring(L, sigils);
        glirc_free_string(sigils);

        return 1;
}

/***
Return the client's nickname on a particular network
@function my_nick
@tparam string network Network name
@treturn ?string Client user's nickname if connected, otherwise `nil`
@usage glirc.my_nick('mynet') --> 'mynick'
*/
static int glirc_lua_my_nick(lua_State *L)
{
        size_t netlen = 0;
        const char *net = luaL_checklstring(L, 1, &netlen);
        luaL_checktype(L, 2, LUA_TNONE);

        char *nick = glirc_my_nick(get_glirc(L), net, netlen);
        lua_pushstring(L, nick);
        glirc_free_string(nick);

        return 1;
}

/***
Mark a client window seen cleaning the unread message counter. The
window name should be either a channel name or a user nickname.
@function mark_seen
@tparam string network Network name
@tparam string channel Window name
@usage
glirc.mark_seen('mynet', '#somechan') -- channel
glirc.mark_seen('mynet', 'chatter') -- direct message
*/
static int glirc_lua_mark_seen(lua_State *L)
{
        size_t network_len, channel_len;
        const char *network, *channel;
        network = luaL_optlstring(L, 1, NULL, &network_len);
        channel = luaL_optlstring(L, 2, NULL, &channel_len);
        luaL_checktype(L, 3, LUA_TNONE);

        glirc_mark_seen(get_glirc(L), network, network_len,
                                      channel, channel_len);
        return 0;
}

/***
Clear all message from a client window. The window name should be
either a channel name or a user nickname.
@function clear_window
@tparam string network Network name
@tparam string channel Window name
@usage
glirc.clear_window('mynet', '#somechan') -- channel
glirc.clear_window('mynet', 'chatter') -- direct message
*/
static int glirc_lua_clear_window(lua_State *L)
{
        size_t network_len, channel_len;
        const char *network, *channel;
        network = luaL_optlstring(L, 1, NULL, &network_len);
        channel = luaL_optlstring(L, 2, NULL, &channel_len);
        luaL_checktype(L, 3, LUA_TNONE);

        glirc_clear_window(get_glirc(L), network, network_len,
                                         channel, channel_len);
        return 0;
}

/***
Get currently focused window.

The client window `*` is identified by two `nil` values.

The network windows are identified by a network name and `nil` target.

The chat windows are identified by both a network name and a target name.

@function current_focus
@treturn ?string Network name
@treturn ?string Target name
@usage
glirc.current_focus() --> nil, nil
glirc.current_focus() --> 'mynet', nil
glirc.current_focus() --> 'mynet', '#somechan'
*/
static int glirc_lua_current_focus(lua_State *L)
{
        luaL_checktype(L, 1, LUA_TNONE);

        size_t network_len = 0, target_len = 0;
        char *network = NULL, *target = NULL;
        glirc_current_focus(get_glirc(L), &network, &network_len,
                                          &target,  &target_len);

        lua_pushlstring(L, network, network_len);
        lua_pushlstring(L, target, target_len);

        glirc_free_string(network);
        glirc_free_string(target);

        return 2;
}

/***
Determine if we are sure that the given user on the given network is
currently connected.
@function is_logged_on
@tparam string network Network name
@tparam string nickname Nickname
@treturn boolean User known to be connected
@usage glirc.is_logged_on('mynet', 'chatter')
*/
static int glirc_lua_is_logged_on(lua_State *L)
{
        size_t network_len = 0, target_len = 0;
        const char *network = NULL, *target = NULL;
        network = luaL_checklstring(L, 1, &network_len);
        target  = luaL_checklstring(L, 2, &target_len);
        luaL_checktype(L, 3, LUA_TNONE);

        int res = glirc_is_logged_on(get_glirc(L), network, network_len,
                                                   target, target_len);
        lua_pushboolean(L, res);

        return 1;
}

/***
Test if target identifies a channel.

This provides a network-specific test to determine if a target name
identifies a channel.  While most networks use `#` to prefix channel
names, there are other possibilities.

@function is_channel
@tparam string network Network name
@tparam string target Target name
@treturn boolean Target is a channel name
@usage
glirc.is_channel('mynet', 'chatter') --> false
glirc.is_channel('mynet', '#somechan') --> true
glirc.is_channel('mynet', '&somechan') --> true
*/
static int glirc_lua_is_channel(lua_State *L)
{
        size_t network_len = 0, target_len = 0;
        const char *network = NULL, *target = NULL;
        network = luaL_checklstring(L, 1, &network_len);
        target  = luaL_checklstring(L, 2, &target_len);
        luaL_checktype(L, 3, LUA_TNONE);

        int res = glirc_is_channel(get_glirc(L), network, network_len,
                                                 target, target_len);
        lua_pushboolean(L, res);

        return 1;
}

/***
Resolve file path.

This provides access to the same path resolution logic used by the
client configuration file. Relative paths are resolved from the
directory containing the loaded configuration file. `~` is expanded to
the home directory.

@function resolve_path
@tparam string path Path
@treturn string Absolute file path
@usage
-- assuming configuration is at '/home/user/.config/glirc/config'
glirc.resolve_path('relative/path') --> 'home/user/.config/glirc/relative/path'
glirc.resolve_path('/absolute/path') --> '/abbsolute/path'
glirc.resolve_path('~/path') --> '/home/user/path'
*/
static int glirc_lua_resolve_path(lua_State *L)
{
        size_t path_len;
        const char *path;
        path = luaL_checklstring(L, 1, &path_len);
        luaL_checktype(L, 2, LUA_TNONE);

        char * res = glirc_resolve_path(get_glirc(L), path, path_len);
        lua_pushstring(L, res);
        glirc_free_string(res);

        return 1;
}

static void on_timer(struct glirc *G, void *S, void *dat) {
        lua_State *L = S;
        int ref = (int)(intptr_t)dat;
        lua_rawgeti(L, LUA_REGISTRYINDEX, ref);
        luaL_unref(L, LUA_REGISTRYINDEX, ref);
        if (lua_pcall(L, 0, 0, 0)) {
                size_t len;
                const char *msg = lua_tolstring(L, -1, &len);
                glirc_print(G, ERROR_MESSAGE, msg, len);
                lua_remove(L, -1);
        }
}

static int glirc_lua_set_timer(lua_State *L)
{
        lua_Integer millis = luaL_checkinteger(L, 1);
        luaL_checktype(L, 3, LUA_TNONE);
        lua_settop(L, 2);
        int ref = luaL_ref(L, LUA_REGISTRYINDEX);
        glirc_set_timer(get_glirc(L), millis, on_timer, (void*)(intptr_t)ref);
        return 0;
}

/***
Case-insensitive comparison of two identifiers using IRC case map.
Return -1 when first identifier is "less than" the second.
Return 0 when first identifier is "equal to" the second.
Return 1 when first identifier is "greater than" the second.
@function identifier_cmp
@tparam string identifier1 First identifier
@tparam string identifier2 Second identifier
@treturn integer Comparison result
@usage
glirc.identifier_cmp('somenick', 'SOMENICK') --> 0
glirc.identifier_cmp('surprise{|}~', 'surprise[\\]^') --> 0
glirc.identifier_cmp('apple', 'zebra') --> -1
glirc.identifier_cmp('zebra', 'apple') --> 1
*/
static int glirc_lua_identifier_cmp(lua_State *L)
{
        size_t str1_len, str2_len;
        const char *str1, *str2;
        str1 = luaL_checklstring(L, 1, &str1_len);
        str2 = luaL_checklstring(L, 2, &str2_len);
        luaL_checktype(L, 3, LUA_TNONE);

        int res = glirc_identifier_cmp(str1, str1_len, str2, str2_len);
        lua_pushinteger(L, res);

        return 1;
}

static void new_formatting_table(lua_State *L) {
        lua_createtable(L, 0, 21);

        lua_pushliteral(L, "\x0f");
        lua_setfield(L, -2, "reset");

        lua_pushliteral(L, "\x1f"); \
        lua_setfield(L, -2, "underline");
        lua_pushliteral(L, "\x1d"); \
        lua_setfield(L, -2, "italic");
        lua_pushliteral(L, "\x02"); \
        lua_setfield(L, -2, "bold");
        lua_pushliteral(L, "\x16"); \
        lua_setfield(L, -2, "reverse");

#define COLOR(name, code) \
        lua_pushstring(L, "\x03" code); \
        lua_setfield(L, -2, name);

        COLOR("white"      , "00")
        COLOR("black"      , "01")
        COLOR("blue"       , "02")
        COLOR("green"      , "03")
        COLOR("red"        , "04")
        COLOR("brown"      , "05")
        COLOR("purple"     , "06")
        COLOR("orange"     , "07")
        COLOR("yellow"     , "08")
        COLOR("light_green", "09")
        COLOR("cyan"       , "10")
        COLOR("light_cyan" , "11")
        COLOR("light_blue" , "12")
        COLOR("pink"       , "13")
        COLOR("gray"       , "14")
        COLOR("light_gray" , "15")
#undef COLOR
}

static luaL_Reg glirc_lib[] =
  { { "send_message"      , glirc_lua_send_message       }
  , { "inject_chat"       , glirc_lua_inject_chat        }
  , { "print"             , glirc_lua_print              }
  , { "error"             , glirc_lua_error              }
  , { "identifier_cmp"    , glirc_lua_identifier_cmp     }
  , { "list_networks"     , glirc_lua_list_networks      }
  , { "list_channels"     , glirc_lua_list_channels      }
  , { "list_channel_users", glirc_lua_list_channel_users }
  , { "my_nick"           , glirc_lua_my_nick            }
  , { "user_account"      , glirc_lua_user_account       }
  , { "user_channel_modes", glirc_lua_user_channel_modes }
  , { "mark_seen"         , glirc_lua_mark_seen          }
  , { "clear_window"      , glirc_lua_clear_window       }
  , { "current_focus"     , glirc_lua_current_focus      }
  , { "is_logged_on"      , glirc_lua_is_logged_on       }
  , { "is_channel"        , glirc_lua_is_channel         }
  , { "resolve_path"      , glirc_lua_resolve_path       }
  , { "set_timer"         , glirc_lua_set_timer          }
  , { NULL                , NULL                         }
  };

/* Helper function
 * Installs the 'glirc' library into the global environment
 * No stack effect
 */
void glirc_install_lib(lua_State *L)
{
        luaL_newlib(L, glirc_lib);

        /* add version table */
        lua_createtable(L, 0, 2);
        lua_pushinteger(L, MAJOR);
        lua_setfield   (L, -2, "major");
        lua_pushinteger(L, MINOR);
        lua_setfield   (L, -2, "minor");
        lua_setfield   (L, -2, "version");

        new_formatting_table(L);
        lua_setfield   (L, -2, "format");

        lua_setglobal(L, "glirc");
}

