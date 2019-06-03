//
//  EmojiDataSource.swift
//  EmojiCollectionView
//
//  Created by Takuya Yokoyama on 2019/06/03.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import Foundation

public enum EmojiDataSource: String, CaseIterable {
    case smileys
    case peopleAndFantasy
    case clothingAndAccessories
    case animalsAndNature
    case foodAndDrink
    case activityAndSports
    case travelAndPlaces
    case objects
    case symbols
    case flags
    
    public var example: String {
        return self.values.first!
    }
    
    public var values: [String] {
        switch self {
        case .smileys:
            return [
                "😀", "😁", "😂", "🤣", "😃", "😄", "😅", "😆", "😉", "😊",
                "😋", "😎", "😍", "😘", "🥰", "😗", "😙", "😚", "☺️", "🙂",
                "🤗", "🤩", "🤔", "🤨", "😐", "😑", "😶", "🙄", "😏", "😣",
                "😥", "😮", "🤐", "😯", "😪", "😫", "😴", "😌", "😛", "😜",
                "😝", "🤤", "😒", "😓", "😔", "😕", "🙃", "🤑", "😲", "☹️",
                "🙁", "😖", "😞", "😟", "😤", "😢", "😭", "😦", "😧", "😨",
                "😩", "🤯", "😬", "😰", "😱", "🥵", "🥶", "😳", "🤪", "😵",
                "😡", "😠", "🤬", "😷", "🤒", "🤕", "🤢", "🤮", "🤧", "😇",
                "🤠", "🤡", "🥳", "🥴", "🥺", "🤥", "🤫", "🤭", "🧐", "🤓",
                "😈", "👿", "👹", "👺", "💀", "👻", "👽", "🤖", "💩", "😺",
                "😸", "😹", "😻", "😼", "😽", "🙀", "😿", "😾"
            ]
        case .peopleAndFantasy:
            return [
                "👶", "👧", "🧒", "👦", "👩", "🧑", "👨", "👵", "🧓", "👴",
                "👲", "👳‍♀️", "👳‍♂️", "🧕", "🧔", "👱‍♂️", "👱‍♀️", "👨‍🦰", "👩‍🦰", "👨‍🦱",
                "👩‍🦱", "👨‍🦲", "👩‍🦲", "👨‍🦳", "👩‍🦳", "🦸‍♀️", "🦸‍♂️", "🦹‍♀️", "🦹‍♂️", "👮‍♀️",
                "👮‍♂️", "👷‍♀️", "👷‍♂️", "💂‍♀️", "💂‍♂️", "🕵️‍♀️", "🕵️‍♂️", "👩‍⚕️", "👨‍⚕️", "👩‍🌾",
                "👨‍🌾", "👩‍🍳", "👨‍🍳", "👩‍🎓", "👨‍🎓", "👩‍🎤", "👨‍🎤", "👩‍🏫", "👨‍🏫", "👩‍🏭",
                "👨‍🏭", "👩‍💻", "👨‍💻", "👩‍💼", "👨‍💼", "👩‍🔧", "👨‍🔧", "👩‍🔬", "👨‍🔬", "👩‍🎨",
                "👨‍🎨", "👩‍🚒", "👨‍🚒", "👩‍✈️", "👨‍✈️", "👩‍🚀", "👨‍🚀", "👩‍⚖️", "👨‍⚖️", "👰",
                "🤵", "👸", "🤴", "🤶", "🎅", "🧙‍♀️", "🧙‍♂️", "🧝‍♀️", "🧝‍♂️", "🧛‍♀️",
                "🧛‍♂️", "🧟‍♀️", "🧟‍♂️", "🧞‍♀️", "🧞‍♂️", "🧜‍♀️", "🧜‍♂️", "🧚‍♀️", "🧚‍♂️", "👼",
                "🤰", "🤱", "🙇‍♀️", "🙇‍♂️", "💁‍♀️", "💁‍♂️", "🙅‍♀️", "🙅‍♂️", "🙆‍♀️", "🙆‍♂️",
                "🙋‍♀️", "🙋‍♂️", "🤦‍♀️", "🤦‍♂️", "🤷‍♀️", "🤷‍♂️", "🙎‍♀️", "🙎‍♂️", "🙍‍♀️", "🙍‍♂️",
                "💇‍♀️", "💇‍♂️", "💆‍♀️", "💆‍♂️", "🧖‍♀️", "🧖‍♂️", "💅", "🤳", "💃", "🕺",
                "👯‍♀️", "👯‍♂️", "🕴", "🚶‍♀️", "🚶‍♂️", "🏃‍♀️", "🏃‍♂️", "👫", "👭", "👬",
                "💑", "👩‍❤️‍👩", "👨‍❤️‍👨", "💏", "👩‍❤️‍💋‍👩", "👨‍❤️‍💋‍👨", "👪", "👨‍👩‍👧", "👨‍👩‍👧‍👦", "👨‍👩‍👦‍👦",
                "👨‍👩‍👧‍👧", "👩‍👩‍👦", "👩‍👩‍👧", "👩‍👩‍👧‍👦", "👩‍👩‍👦‍👦", "👩‍👩‍👧‍👧", "👨‍👨‍👦", "👨‍👨‍👧", "👨‍👨‍👧‍👦", "👨‍👨‍👦‍👦",
                "👨‍👨‍👧‍👧", "👩‍👦", "👩‍👧", "👩‍👧‍👦", "👩‍👦‍👦", "👩‍👧‍👧", "👨‍👦", "👨‍👧", "👨‍👧‍👦", "👨‍👦‍👦",
                "👨‍👧‍👧", "🤲", "👐", "🙌", "👏", "🤝", "👍", "👎", "👊", "✊",
                "🤛", "🤜", "🤞", "✌️", "🤟", "🤘", "👌", "👈", "👉", "👆",
                "👇", "☝️", "✋", "🤚", "🖐", "🖖", "👋", "🤙", "💪", "🦵",
                "🦶", "🖕", "✍️", "🙏", "💍", "💄", "💋", "👄", "👅", "👂",
                "👃", "👣", "👁", "👀", "🧠", "🦴", "🦷", "🗣", "👤", "👥"
            ]
        case .clothingAndAccessories:
            return [
                "🧥", "👚", "👕", "👖", "👔", "👗", "👙", "👘", "👠", "👡",
                "👢", "👞", "👟", "🥾", "🥿", "🧦", "🧤", "🧣", "🎩", "🧢",
                "👒", "🎓", "⛑", "👑", "👝", "👛", "👜", "💼", "🎒", "👓",
                "🕶", "🥽", "🥼", "🌂", "🧵", "🧶"
            ]
        case .animalsAndNature:
            return [
                "🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🦝", "🐻", "🐼", "🦘",
                "🦡", "🐨", "🐯", "🦁", "🐮", "🐷", "🐽", "🐸", "🐵", "🙈",
                "🙉", "🙊", "🐒", "🐔", "🐧", "🐦", "🐤", "🐣", "🐥", "🦆",
                "🦢", "🦅", "🦉", "🦚", "🦜", "🦇", "🐺", "🐗", "🐴", "🦄",
                "🐝", "🐛", "🦋", "🐌", "🐚", "🐞", "🐜", "🦗", "🕷", "🕸",
                "🦂", "🦟", "🦠", "🐢", "🐍", "🦎", "🦖", "🦕", "🐙", "🦑",
                "🦐", "🦀", "🐡", "🐠", "🐟", "🐬", "🐳", "🐋", "🦈", "🐊",
                "🐅", "🐆", "🦓", "🦍", "🐘", "🦏", "🦛", "🐪", "🐫", "🦙",
                "🦒", "🐃", "🐂", "🐄", "🐎", "🐖", "🐏", "🐑", "🐐", "🦌",
                "🐕", "🐩", "🐈", "🐓", "🦃", "🕊", "🐇", "🐁", "🐀", "🐿",
                "🦔", "🐾", "🐉", "🐲", "🌵", "🎄", "🌲", "🌳", "🌴", "🌱",
                "🌿", "☘️", "🍀", "🎍", "🎋", "🍃", "🍂", "🍁", "🍄", "🌾",
                "💐", "🌷", "🌹", "🥀", "🌺", "🌸", "🌼", "🌻", "🌞", "🌝",
                "🌛", "🌜", "🌚", "🌕", "🌖", "🌗", "🌘", "🌑", "🌒", "🌓",
                "🌔", "🌙", "🌎", "🌍", "🌏", "💫", "⭐️", "🌟", "✨", "⚡️",
                "☄️", "💥", "🔥", "🌪", "🌈", "☀️", "🌤", "⛅️", "🌥", "☁️",
                "🌦", "🌧", "⛈", "🌩", "🌨", "❄️", "☃️", "⛄️", "🌬", "💨",
                "💧", "💦", "☔️", "☂️", "🌊", "🌫"
            ]
        case .foodAndDrink:
            return [
                "🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🍈",
                "🍒", "🍑", "🍍", "🥭", "🥥", "🥝", "🍅", "🍆", "🥑", "🥦",
                "🥒", "🥬", "🌶", "🌽", "🥕", "🥔", "🍠", "🥐", "🍞", "🥖",
                "🥨", "🥯", "🧀", "🥚", "🍳", "🥞", "🥓", "🥩", "🍗", "🍖",
                "🌭", "🍔", "🍟", "🍕", "🥪", "🥙", "🌮", "🌯", "🥗", "🥘",
                "🥫", "🍝", "🍜", "🍲", "🍛", "🍣", "🍱", "🥟", "🍤", "🍙",
                "🍚", "🍘", "🍥", "🥮", "🥠", "🍢", "🍡", "🍧", "🍨", "🍦",
                "🥧", "🍰", "🎂", "🍮", "🍭", "🍬", "🍫", "🍿", "🧂", "🍩",
                "🍪", "🌰", "🥜", "🍯", "🥛", "🍼", "☕️", "🍵", "🥤", "🍶",
                "🍺", "🍻", "🥂", "🍷", "🥃", "🍸", "🍹", "🍾", "🥄", "🍴",
                "🍽", "🥣", "🥡", "🥢"
            ]
        case .activityAndSports:
            return [
                "⚽️", "🏀", "🏈", "⚾️", "🥎", "🏐", "🏉", "🎾", "🥏", "🎱",
                "🏓", "🏸", "🥅", "🏒", "🏑", "🥍", "🏏", "⛳️", "🏹", "🎣",
                "🥊", "🥋", "🎽", "⛸", "🥌", "🛷", "🛹", "🎿", "⛷", "🏂",
                "🏋️‍♀️", "🏋️‍♂️", "🤼‍♀️", "🤼‍♂️", "🤸‍♀️", "🤸‍♂️", "⛹️‍♀️", "⛹️‍♂️", "🤺", "🤾‍♀️",
                "🤾‍♂️", "🏌️‍♀️", "🏌️‍♂️", "🏇", "🧘‍♀️", "🧘‍♂️", "🏄‍♀️", "🏄‍♂️", "🏊‍♀️", "🏊‍♂️",
                "🤽‍♀️", "🤽‍♂️", "🚣‍♀️", "🚣‍♂️", "🧗‍♀️", "🧗‍♂️", "🚵‍♀️", "🚵‍♂️", "🚴‍♀️", "🚴‍♂️",
                "🏆", "🥇", "🥈", "🥉", "🏅", "🎖", "🏵", "🎗", "🎫", "🎟",
                "🎪", "🤹‍♀️", "🤹‍♂️", "🎭", "🎨", "🎬", "🎤", "🎧", "🎼", "🎹",
                "🥁", "🎷", "🎺", "🎸", "🎻", "🎲", "🧩", "♟", "🎯", "🎳",
                "🎮", "🎰"
            ]
        case .travelAndPlaces:
            return [
                "🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐",
                "🚚", "🚛", "🚜", "🛴", "🚲", "🛵", "🏍", "🚨", "🚔", "🚍",
                "🚘", "🚖", "🚡", "🚠", "🚟", "🚃", "🚋", "🚞", "🚝", "🚄",
                "🚅", "🚈", "🚂", "🚆", "🚇", "🚊", "🚉", "✈️", "🛫", "🛬",
                "🛩", "💺", "🛰", "🚀", "🛸", "🚁", "🛶", "⛵️", "🚤", "🛥",
                "🛳", "⛴", "🚢", "⚓️", "⛽️", "🚧", "🚦", "🚥", "🚏", "🗺",
                "🗿", "🗽", "🗼", "🏰", "🏯", "🏟", "🎡", "🎢", "🎠", "⛲️",
                "⛱", "🏖", "🏝", "🏜", "🌋", "⛰", "🏔", "🗻", "🏕", "⛺️",
                "🏠", "🏡", "🏘", "🏚", "🏗", "🏭", "🏢", "🏬", "🏣", "🏤",
                "🏥", "🏦", "🏨", "🏪", "🏫", "🏩", "💒", "🏛", "⛪️", "🕌",
                "🕍", "🕋", "⛩", "🛤", "🛣", "🗾", "🎑", "🏞", "🌅", "🌄",
                "🌠", "🎇", "🎆", "🌇", "🌆", "🏙", "🌃", "🌌", "🌉", "🌁"
            ]
        case .objects:
            return [
                "⌚️", "📱", "📲", "💻", "⌨️", "🖥", "🖨", "🖱", "🖲", "🕹",
                "🗜", "💽", "💾", "💿", "📀", "📼", "📷", "📸", "📹", "🎥",
                "📽", "🎞", "📞", "☎️", "📟", "📠", "📺", "📻", "🎙", "🎚",
                "🎛", "⏱", "⏲", "⏰", "🕰", "⌛️", "⏳", "📡", "🔋", "🔌",
                "💡", "🔦", "🕯", "🗑", "🛢", "💸", "💵", "💴", "💶", "💷",
                "💰", "💳", "🧾", "💎", "⚖️", "🔧", "🔨", "⚒", "🛠", "⛏",
                "🔩", "⚙️", "⛓", "🔫", "💣", "🔪", "🗡", "⚔️", "🛡", "🚬",
                "⚰️", "⚱️", "🏺", "🧭", "🧱", "🔮", "🧿", "🧸", "📿", "💈",
                "⚗️", "🔭", "🧰", "🧲", "🧪", "🧫", "🧬", "🧯", "🔬", "🕳",
                "💊", "💉", "🌡", "🚽", "🚰", "🚿", "🛁", "🛀", "🛀🏻", "🛀🏼",
                "🛀🏽", "🛀🏾", "🛀🏿", "🧴", "🧵", "🧶", "🧷", "🧹", "🧺", "🧻",
                "🧼", "🧽", "🛎", "🔑", "🗝", "🚪", "🛋", "🛏", "🛌", "🖼",
                "🛍", "🧳", "🛒", "🎁", "🎈", "🎏", "🎀", "🎊", "🎉", "🧨",
                "🎎", "🏮", "🎐", "🧧", "✉️", "📩", "📨", "📧", "💌", "📥",
                "📤", "📦", "🏷", "📪", "📫", "📬", "📭", "📮", "📯", "📜",
                "📃", "📄", "📑", "📊", "📈", "📉", "🗒", "🗓", "📆", "📅",
                "📇", "🗃", "🗳", "🗄", "📋", "📁", "📂", "🗂", "🗞", "📰",
                "📓", "📔", "📒", "📕", "📗", "📘", "📙", "📚", "📖", "🔖",
                "🔗", "📎", "🖇", "📐", "📏", "📌", "📍", "✂️", "🖊", "🖋",
                "✒️", "🖌", "🖍", "📝", "✏️", "🔍", "🔎", "🔏", "🔐", "🔒",
                "🔓"
            ]
        case .symbols:
            return [
                "❤️", "🧡", "💛", "💚", "💙", "💜", "🖤", "💔", "❣️", "💕",
                "💞", "💓", "💗", "💖", "💘", "💝", "💟", "☮️", "✝️", "☪️",
                "🕉", "☸️", "✡️", "🔯", "🕎", "☯️", "☦️", "🛐", "⛎", "♈️",
                "♉️", "♊️", "♋️", "♌️", "♍️", "♎️", "♏️", "♐️", "♑️", "♒️",
                "♓️", "🆔", "⚛️", "🉑", "☢️", "☣️", "📴", "📳", "🈶", "🈚️",
                "🈸", "🈺", "🈷️", "✴️", "🆚", "💮", "🉐", "㊙️", "㊗️", "🈴",
                "🈵", "🈹", "🈲", "🅰️", "🅱️", "🆎", "🆑", "🅾️", "🆘", "❌",
                "⭕️", "🛑", "⛔️", "📛", "🚫", "💯", "💢", "♨️", "🚷", "🚯",
                "🚳", "🚱", "🔞", "📵", "🚭", "❗️", "❕", "❓", "❔", "‼️",
                "⁉️", "🔅", "🔆", "〽️", "⚠️", "🚸", "🔱", "⚜️", "🔰", "♻️",
                "✅", "🈯️", "💹", "❇️", "✳️", "❎", "🌐", "💠", "Ⓜ️", "🌀",
                "💤", "🏧", "🚾", "♿️", "🅿️", "🈳", "🈂️", "🛂", "🛃", "🛄",
                "🛅", "🚹", "🚺", "🚼", "🚻", "🚮", "🎦", "📶", "🈁", "🔣",
                "ℹ️", "🔤", "🔡", "🔠", "🆖", "🆗", "🆙", "🆒", "🆕", "🆓",
                "0️⃣", "1️⃣", "2️⃣", "3️⃣", "4️⃣", "5️⃣", "6️⃣", "7️⃣", "8️⃣", "9️⃣",
                "🔟", "🔢", "#️⃣", "*️⃣", "⏏️", "▶️", "⏸", "⏯", "⏹", "⏺",
                "⏭", "⏮", "⏩", "⏪", "⏫", "⏬", "◀️", "🔼", "🔽", "➡️",
                "⬅️", "⬆️", "⬇️", "↗️", "↘️", "↙️", "↖️", "↕️", "↔️", "↪️",
                "↩️", "⤴️", "⤵️", "🔀", "🔁", "🔂", "🔄", "🔃", "🎵", "🎶",
                "➕", "➖", "➗", "✖️", "♾", "💲", "💱", "™️", "©️", "®️",
                "〰️", "➰", "➿", "🔚", "🔙", "🔛", "🔝", "🔜", "✔️", "☑️",
                "🔘", "⚪️", "⚫️", "🔴", "🔵", "🔺", "🔻", "🔸", "🔹", "🔶",
                "🔷", "🔳", "🔲", "▪️", "▫️", "◾️", "◽️", "◼️", "◻️", "⬛️",
                "⬜️", "🔈", "🔇", "🔉", "🔊", "🔔", "🔕", "📣", "📢", "👁‍🗨",
                "💬", "💭", "🗯", "♠️", "♣️", "♥️", "♦️", "🃏", "🎴", "🀄️",
                "🕐", "🕑", "🕒", "🕓", "🕔", "🕕", "🕖", "🕗", "🕘", "🕙",
                "🕚", "🕛", "🕜", "🕝", "🕞", "🕟", "🕠", "🕡", "🕢", "🕣",
                "🕤", "🕥", "🕦", "🕧"
            ]
        case .flags:
            return [
                "🏳️", "🏴", "🏁", "🚩", "🏳️‍🌈", "🏴‍☠️", "🇦🇫", "🇦🇽", "🇦🇱", "🇩🇿",
                "🇦🇸", "🇦🇩", "🇦🇴", "🇦🇮", "🇦🇶", "🇦🇬", "🇦🇷", "🇦🇲", "🇦🇼", "🇦🇺",
                "🇦🇹", "🇦🇿", "🇧🇸", "🇧🇭", "🇧🇩", "🇧🇧", "🇧🇾", "🇧🇪", "🇧🇿", "🇧🇯",
                "🇧🇲", "🇧🇹", "🇧🇴", "🇧🇦", "🇧🇼", "🇧🇷", "🇮🇴", "🇻🇬", "🇧🇳", "🇧🇬",
                "🇧🇫", "🇧🇮", "🇰🇭", "🇨🇲", "🇨🇦", "🇮🇨", "🇨🇻", "🇧🇶", "🇰🇾", "🇨🇫",
                "🇹🇩", "🇨🇱", "🇨🇳", "🇨🇽", "🇨🇨", "🇨🇴", "🇰🇲", "🇨🇬", "🇨🇩", "🇨🇰",
                "🇨🇷", "🇨🇮", "🇭🇷", "🇨🇺", "🇨🇼", "🇨🇾", "🇨🇿", "🇩🇰", "🇩🇯", "🇩🇲",
                "🇩🇴", "🇪🇨", "🇪🇬", "🇸🇻", "🇬🇶", "🇪🇷", "🇪🇪", "🇪🇹", "🇪🇺", "🇫🇰",
                "🇫🇴", "🇫🇯", "🇫🇮", "🇫🇷", "🇬🇫", "🇵🇫", "🇹🇫", "🇬🇦", "🇬🇲", "🇬🇪",
                "🇩🇪", "🇬🇭", "🇬🇮", "🇬🇷", "🇬🇱", "🇬🇩", "🇬🇵", "🇬🇺", "🇬🇹", "🇬🇬",
                "🇬🇳", "🇬🇼", "🇬🇾", "🇭🇹", "🇭🇳", "🇭🇰", "🇭🇺", "🇮🇸", "🇮🇳", "🇮🇩",
                "🇮🇷", "🇮🇶", "🇮🇪", "🇮🇲", "🇮🇱", "🇮🇹", "🇯🇲", "🇯🇵", "🎌", "🇯🇪",
                "🇯🇴", "🇰🇿", "🇰🇪", "🇰🇮", "🇽🇰", "🇰🇼", "🇰🇬", "🇱🇦", "🇱🇻", "🇱🇧",
                "🇱🇸", "🇱🇷", "🇱🇾", "🇱🇮", "🇱🇹", "🇱🇺", "🇲🇴", "🇲🇰", "🇲🇬", "🇲🇼",
                "🇲🇾", "🇲🇻", "🇲🇱", "🇲🇹", "🇲🇭", "🇲🇶", "🇲🇷", "🇲🇺", "🇾🇹", "🇲🇽",
                "🇫🇲", "🇲🇩", "🇲🇨", "🇲🇳", "🇲🇪", "🇲🇸", "🇲🇦", "🇲🇿", "🇲🇲", "🇳🇦",
                "🇳🇷", "🇳🇵", "🇳🇱", "🇳🇨", "🇳🇿", "🇳🇮", "🇳🇪", "🇳🇬", "🇳🇺", "🇳🇫",
                "🇰🇵", "🇲🇵", "🇳🇴", "🇴🇲", "🇵🇰", "🇵🇼", "🇵🇸", "🇵🇦", "🇵🇬", "🇵🇾",
                "🇵🇪", "🇵🇭", "🇵🇳", "🇵🇱", "🇵🇹", "🇵🇷", "🇶🇦", "🇷🇪", "🇷🇴", "🇷🇺",
                "🇷🇼", "🇼🇸", "🇸🇲", "🇸🇦", "🇸🇳", "🇷🇸", "🇸🇨", "🇸🇱", "🇸🇬", "🇸🇽",
                "🇸🇰", "🇸🇮", "🇬🇸", "🇸🇧", "🇸🇴", "🇿🇦", "🇰🇷", "🇸🇸", "🇪🇸", "🇱🇰",
                "🇧🇱", "🇸🇭", "🇰🇳", "🇱🇨", "🇵🇲", "🇻🇨", "🇸🇩", "🇸🇷", "🇸🇿", "🇸🇪",
                "🇨🇭", "🇸🇾", "🇹🇼", "🇹🇯", "🇹🇿", "🇹🇭", "🇹🇱", "🇹🇬", "🇹🇰", "🇹🇴",
                "🇹🇹", "🇹🇳", "🇹🇷", "🇹🇲", "🇹🇨", "🇹🇻", "🇻🇮", "🇺🇬", "🇺🇦", "🇦🇪",
                "🇬🇧", "🏴󠁧󠁢󠁥󠁮󠁧󠁿", "🏴󠁧󠁢󠁳󠁣󠁴󠁿", "🏴󠁧󠁢󠁷󠁬󠁳󠁿", "🇺🇳", "🇺🇸", "🇺🇾", "🇺🇿", "🇻🇺", "🇻🇦",
                "🇻🇪", "🇻🇳", "🇼🇫", "🇪🇭", "🇾🇪", "🇿🇲", "🇿🇼"
            ]
        }
    }
}
