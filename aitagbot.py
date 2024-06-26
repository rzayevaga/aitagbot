from time import time
from datetime import datetime
from pyrogram import Client, filters
from pyrogram.types import Message, InlineKeyboardMarkup, InlineKeyboardButton
from pyrogram.types import Message
import os
import asyncio
from pyrogram import enums
from pyrogram.enums import ChatMemberStatus
from pyrogram.errors import FloodWait

rzayev=Client(
    "AiTagBot",
    api_id = int(os.environ["API_ID"]),
    api_hash = os.environ["API_HASH"],
    bot_token = os.environ["BOT_TOKEN"]
)

chatQueue = []

stopProcess = False

@rzayev.on_message(filters.command(["ai","all", "tag", "aitagbot", "@aitag_bot", "aitag"]))
async def everyone(client, message):
  global stopProcess
  try: 
    try:
      sender = await rzayev.get_chat_member(message.chat.id, message.from_user.id)
      has_permissions = sender.privileges
    except:
      has_permissions = message.sender_chat  
    if has_permissions:
      if len(chatQueue) > 5:
        await message.reply("⛔️ | Hazırda maksimum 5 söhbətim üzərində işləyirəm.  Lütfən, tezliklə yenidən cəhd edin.")
      else:  
        if message.chat.id in chatQueue:
          await message.reply("🚫 | Bu çatda artıq davam edən proses var.  Yenisini başlamaq üçün zəhmət olmasa /stop əmrini işlədin.")
        else:  
          chatQueue.append(message.chat.id)
          if len(message.command) > 1:
            inputText = message.command[1]
          elif len(message.command) == 1:
            inputText = ""    
          membersList = []
          async for member in rzayev.get_chat_members(message.chat.id):
            if member.user.is_bot == True:
              pass
            elif member.user.is_deleted == True:
              pass
            else:
              membersList.append(member.user)
          i = 0
          lenMembersList = len(membersList)
          if stopProcess: stopProcess = False
          while len(membersList) > 0 and not stopProcess :
            j = 0
            text1 = f"{inputText}\n\n"
            try:    
              while j < 10:
                user = membersList.pop(0)
                if user.username == None:
                  text1 += f"{user.mention} "
                  j+=1
                else:
                  text1 += f"@{user.username} "
                  j+=1
              try:     
                await rzayev.send_message(message.chat.id, text1)
              except Exception:
                pass  
              await asyncio.sleep(10) 
              i+=10
            except IndexError:
              try:
                await rzayev.send_message(message.chat.id, text1)  
              except Exception:
                pass  
              i = i+j
          if i == lenMembersList:    
            await message.reply(f"✅ | Uğurla qeyd olundu **üzvlərin ümumi sayı: {i}**.\n❌ |  Botlar və silinmiş hesablar rədd edildi.") 
          else:
            await message.reply(f"✅ | **{i} üzvlərin adı uğurla qeyd olundu.**\n❌ |  Botlar və silinmiş hesablar rədd edildi.")    
          chatQueue.remove(message.chat.id)
    else:
      await message.reply("👮🏻 | Üzr istəyirik, **yalnız adminlər** bu əmri işlədə bilər.")  
  except FloodWait as e:
    await asyncio.sleep(e.value) 

@rzayev.on_message(filters.command(["remove","clean", "sil"]))
async def remove(client, message):
  global stopProcess
  try: 
    try:
      sender = await rzayev.get_chat_member(message.chat.id, message.from_user.id)
      has_permissions = sender.privileges
    except:
      has_permissions = message.sender_chat  
    if has_permissions:
      bot = await rzayev.get_chat_member(message.chat.id, "self")
      if bot.status == ChatMemberStatus.MEMBER:
        await message.reply("🕹 Silinmiş hesabları qrupdan atmaq üçün mənə admin icazələri lazımdır.")  
      else:  
        if len(chatQueue) > 5 :
          await message.reply("⛔️ | Hazırda maksimum 5 söhbətim üzərində işləyirəm.  Lütfən, tezliklə yenidən cəhd edin.")
        else:  
          if message.chat.id in chatQueue:
            await message.reply("🚫 | Bu çatda artıq davam edən proses var.  Yenisini başlamaq üçün zəhmət olmasa ilk olaraq /cancel əmrindənə istifadə et.")
          else:  
            chatQueue.append(message.chat.id)  
            deletedList = []
            async for member in rzayev.get_chat_members(message.chat.id):
              if member.user.is_deleted == True:
                deletedList.append(member.user)
              else:
                pass
            lenDeletedList = len(deletedList)  
            if lenDeletedList == 0:
              await message.reply("👻 | Bu söhbətdə silinmiş hesab yoxdur.")
              chatQueue.remove(message.chat.id)
            else:
              k = 0
              processTime = lenDeletedList*10
              temp = await rzayev.send_message(message.chat.id, f"🚨 | cəmi {lenDeletedList} silinmiş hesab aşkarlandı.\n⏳ |  təxmini vaxt: indidən {processTime} saniyə.")
              if stopProcess: stopProcess = False
              while len(deletedList) > 0 and not stopProcess:   
                deletedAccount = deletedList.pop(0)
                try:
                  await rzayev.ban_chat_member(message.chat.id, deletedAccount.id)
                except Exception:
                  pass  
                k+=1
                await asyncio.sleep(10)
              if k == lenDeletedList:  
                await message.reply(f"✅ | Bütün silinmiş hesablar bu söhbətdən uğurla atıldı.")  
                await temp.delete()
              else:
                await message.reply(f"✅ | {k} silinmiş hesabı bu söhbətdən uğurla atdı.")  
                await temp.delete()  
              chatQueue.remove(message.chat.id)
    else:
      await message.reply("👮🏻 | Üzr istəyirik, **yalnız adminlər** bu əmri yerinə yetirə bilər.")  
  except FloodWait as e:
    await asyncio.sleep(e.value)                               
        
@rzayev.on_message(filters.command(["stop","cancel", "dayan"]))
async def stop(client, message):
  global stopProcess
  try:
    try:
      sender = await rzayev.get_chat_member(message.chat.id, message.from_user.id)
      has_permissions = sender.privileges
    except:
      has_permissions = message.sender_chat  
    if has_permissions:
      if not message.chat.id in chatQueue:
        await message.reply("🤷🏻‍♀️ | Dayandırmaq üçün davam edən proses yoxdur.")
      else:
        stopProcess = True
        await message.reply("🛑 | Tağ prosesi Dayandı.")
    else:
      await message.reply("👮🏻 | Üzr istəyirik, **yalnız adminlər** bu əmri yerinə yetirə bilər.")
  except FloodWait as e:
    await asyncio.sleep(e.value)

@rzayev.on_message(filters.command(["admins","staff"]))
async def admins(client, message):
  try: 
    adminList = []
    ownerList = []
    async for admin in rzayev.get_chat_members(message.chat.id, filter=enums.ChatMembersFilter.ADMINISTRATORS):
      if admin.privileges.is_anonymous == False:
        if admin.user.is_bot == True:
          pass
        elif admin.status == ChatMemberStatus.OWNER:
          ownerList.append(admin.user)
        else:  
          adminList.append(admin.user)
      else:
        pass   
    lenAdminList= len(ownerList) + len(adminList)  
    text2 = f"**GROUP STAFF - {message.chat.title}**\n\n"
    try:
      owner = ownerList[0]
      if owner.username == None:
        text2 += f"👑 Sahib\n└ {owner.mention}\n\n👮🏻 Adminlər\n"
      else:
        text2 += f"👑 Sahib\n└ @{owner.username}\n\n👮🏻 Adminlər\n"
    except:
      text2 += f"👑 Sahib\n└ <i>Gizli</i>\n\n👮🏻 Adminlər\n"
    if len(adminList) == 0:
      text2 += "└ <i>Adminlər gizlidir</i>"  
      await teletips.send_message(message.chat.id, text2)   
    else:  
      while len(adminList) > 1:
        admin = adminList.pop(0)
        if admin.username == None:
          text2 += f"├ {admin.mention}\n"
        else:
          text2 += f"├ @{admin.username}\n"    
      else:    
        admin = adminList.pop(0)
        if admin.username == None:
          text2 += f"└ {admin.mention}\n\n"
        else:
          text2 += f"└ @{admin.username}\n\n"
      text2 += f"✅ | **Adminlərin ümumi sayı**: {lenAdminList}\n❌ | Botlar və gizli adminlər rədd edildi."  
      await rzayev.send_message(message.chat.id, text2)           
  except FloodWait as e:
    await asyncio.sleep(e.value)       

@rzayev.on_message(filters.command(["bots", "bot", "botlar"]))
async def bots(client, message):  
  try:    
    botList = []
    async for bot in rzayev.get_chat_members(message.chat.id, filter=enums.ChatMembersFilter.BOTS):
      botList.append(bot.user)
    lenBotList = len(botList) 
    text3  = f"**BOT LIST - {message.chat.title}**\n\n🤖 Botlar\n"
    while len(botList) > 1:
      bot = botList.pop(0)
      text3 += f"├ @{bot.username}\n"    
    else:    
      bot = botList.pop(0)
      text3 += f"└ @{bot.username}\n\n"
      text3 += f"✅ | **Botların ümumi sayı**: {lenBotList}"  
      await teletips.send_message(message.chat.id, text3)
  except FloodWait as e:
    await asyncio.sleep(e.value)

@rzayev.on_message(filters.command("start") & filters.private)
async def start(client, message):
  text = f'''
Salam {message.from_user.mention},
Mənim adım **aiTag**-dır.  Qrupunuzdakı bütün üzvləri tağ etməklə hər kəsin diqqətini çəkməyə kömək etmək üçün buradayam.

Mənim bəzi əlavə əla xüsusiyyətlərim var və həmçinin kanallarda işləyə bilərəm.

[aiTbots](http://t.me/aitbots)  bütün son yeniləmələr haqqında məlumat almaq üçün kanalıma qoşulmağı unutmayın.

Əmrlərimi və onlardan istifadəni öyrənmək üçün /help düyməsini vurun.
'''
  await rzayev.send_message(message.chat.id, text, disable_web_page_preview=True)


@rzayev.on_message(filters.command(["help"]))
async def help(client, message):
  text = '''
Ooo Gözəl, Əmrlər Aşağıdadır Baxın.

**Əmrlər**:

» /aitag "səbəb": <i>Bütün üzvləri tağ edirəm.</i>
» /sil: <i>Bütün silinmiş hesabları qrupdan atıram.</i>
» /admins: <i>Bütün adminləri tağ edirəm.</i>
» /bots: <i>Qrupda olan botları tağ edirəm.</i>
» /stop: <i>Davam edən tağ prosesini dayandırıram.</i>

Məndən necə istifadə edəcəyinizlə bağlı hər hansı bir sualınız varsa, çəkinmədən sahibimdən soruşun [Sahib'ə Yaz](https://t.me/aiteknoloji).
'''
  await rzayev.send_message(message.chat.id, text, disable_web_page_preview=True)


@rzayev.on_message(filters.command("id"))
async def get_id(client, message):
    try:

        if (not message.reply_to_message) and (message.chat):
            await message.reply(f"{message.from_user.first_name} istifadəçinin ID-si: <code>{message.from_user.id }</code>.\nBu söhbətin ID-si: <code>{message.chat.id}</code>.") 

        elif not message.reply_to_message:
            await message.reply(f"{message.from_user.first_name} Istifadəçinin ID'si: <code>{message.from_user.id }</code>.") 

        elif message.reply_to_message.forward_from_chat:
            await message.reply(f"The forwarded {str(message.reply_to_message.forward_from_chat.type)[9:].lower()}, {message.reply_to_message.forward_from_chat.title} has an ID of <code>{message.reply_to_message.forward_from_chat.id}</code>.") 

        elif message.reply_to_message.forward_from:
            await message.reply(f"Yönləndirilmiş istifadəçi, {message.reply_to_message.forward_from.first_name} adlı istifadəçinin ID-si var <code>{message.reply_to_message.forward_from.id   }</code>.")

        elif message.reply_to_message.forward_sender_name:
            await message.reply("Üzr istəyirik, məxfilik parametrlərinə görə yönləndirilmiş istifadəçi ID-sini əldə edə bilməzsiniz")

        else:
            await message.reply(f"{message.reply_to_message.from_user.first_name} adlı istifadəçinin ID-si <code>{message.reply_to_message.from_user.id}</code>.")   

    except Exception:
            await message.reply("ID-ni əldə edərkən xəta baş verdi.")


@rzayev.on_message(filters.new_chat_members)
async def auto_welcome(bot: Client, msg: Message):
    first = msg.from_user.first_name
    last = msg.from_user.last_name
    mention = msg.from_user.mention
    username = msg.from_user.username
    id = msg.from_user.id
    group_name = msg.chat.title
    group_username = msg.chat.username
    name_button = "🍁 Qoşul 🍁"
    link_button = "https://t.me/aitbots"
    welcome_text = f"**Salam, {mention}, {group_name}-a Xoş gəldin!\n\nSəni aramızda görməyimiza Şaıqm.\n\nQrupa Gəlmisənsə Qrup Qaydalarına əməl et!\n\nSənin ID-in:** `{id}`"
    WELCOME_TEXT = os.environ.get("WELCOME_TEXT", welcome_text)
    print("Xoş gəlmisiniz Mesajı Aktivləşdirin")
    BUTTON = bool(os.environ.get("WELCOME_BUTTON"))
    if not BUTTON:
       await msg.reply_text(text=WELCOME_TEXT.format(
           first = msg.from_user.first_name,
           last = msg.from_user.last_name,
           username = None if not msg.from_user.username else '@' + msg.from_user.username,
           mention = msg.from_user.mention,
           id = msg.from_user.id,
           group_name = msg.chat.title,
           group_username = None if not msg.chat.username else '@' + msg.chat.username
          )
       )
    else:
       await msg.reply_text(text=WELCOME_TEXT.format(
           first = msg.from_user.first_name,
           last = msg.from_user.last_name,
           username = None if not msg.from_user.username else '@' + msg.from_user.username,
           mention = msg.from_user.mention,
           id = msg.from_user.id,
           group_name = msg.chat.title,
           group_username = None if not msg.chat.username else '@' + msg.chat.username
          ),
       reply_markup=InlineKeyboardMarkup(
               [
                   [
                       InlineKeyboardButton
                           (
                               name_button, url=link_button
                           )
                   ]  
               ]
           )
       )  




@rzayev.on_message(filters.left_chat_member)
async def goodbye(bot,message):
	chatid= message.chat.id
	n=await bot.send_message(text=f"Getməyinə üzüldüm,  {message.from_user.mention}, iyi günlər 😔",chat_id=chatid)

@rzayev.on_message(filters.command("ping"))
async def ping_pong(client, message):
    start = time()
    m_reply = await message.reply_text("__pinging...__")
    delta_ping = time() - start
    await m_reply.edit_text("🏓 `PONG!!`\n" f"⚡️ `{delta_ping * 1000:.3f} ms`")


START_TIME = datetime.utcnow()
START_TIME_ISO = START_TIME.replace(microsecond=0).isoformat()
TIME_DURATION_UNITS = (
    ("həftə", 60 * 60 * 24 * 7),
    ("gun", 60 * 60 * 24),
    ("saat", 60 * 60),
    ("dəqiqə", 60),
    ("saniyə", 1)
)

async def _human_time_duration(seconds):
    if seconds == 0:
        return 'inf'
    parts = []
    for unit, div in TIME_DURATION_UNITS:
        amount, seconds = divmod(int(seconds), div)
        if amount > 0:
            parts.append('{} {}{}'
                         .format(amount, unit, "" if amount == 1 else ""))
    return ', '.join(parts)


@rzayev.on_message(filters.command("uptime"))
async def get_uptime(client, message):
    current_time = datetime.utcnow()
    uptime_sec = (current_time - START_TIME).total_seconds()
    uptime = await _human_time_duration(int(uptime_sec))
    await message.reply_text(
        "**aiTag Bot Status:\n\n"
        f"•**uptime:** `{uptime}`\n"
        f"•**start time:** `{START_TIME_ISO}`"
    )



@rzayev.on_message(filters.command("alive"))
async def alive(client, message):
    current_time = datetime.utcnow()
    uptime_sec = (current_time - START_TIME).total_seconds()
    uptime = await _human_time_duration(int(uptime_sec))
    await message.reply_photo(
        photo=f"https://graph.org/file/93b1b1cbf5a3b58262a05.jpg",
        caption=f"""**💠 Mən Çox Gözəl İşləyirəm**\n\n<b>⏰ **uptime:**</b> `{uptime}`""",
        reply_markup=InlineKeyboardMarkup(
            [
                [
                    InlineKeyboardButton(
                        "🧑🏻‍💻 Sahib", url=f"https://t.me/codmastervip"
                    ),
                    InlineKeyboardButton(
                        "📲 Kanal", url=f"https://t.me/aitbots"
                    )
                ]
            ]
        )
    )

print("aitagbot aktivdir!")  
rzayev.run() 
