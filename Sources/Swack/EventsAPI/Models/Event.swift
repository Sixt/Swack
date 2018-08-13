//===----------------------------------------------------------------------===//
//
// This source file is part of the Swack open source project
//
// Copyright (c) 2018 e-Sixt
// Licensed under MIT
//
// See LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

import Foundation

public enum EventType: String, Decodable {
    case appMention = "app_mention"
    case appRateLimited = "app_rate_limited"
    case appUninstall = "app_uninstall"
    case channelArchive = "channel_archive"
    case channelCreated = "channel_created"
    case channelDeleted = "channel_deleted"
    case channelHistoryChanged = "channel_history_changed"
    case channelLeft = "channel_left"
    case channelRename = "channel_rename"
    case channelUnarchive = "channel_unarchive"
    case commandsChanged = "commands_changed"
    case dndUpdated = "dnd_updated"
    case dndUpdatedUser = "dnd_updated_user"
    case emailDomainChanged = "email_domain_changed"
    case emojiChanged = "emoji_changed"
    case fileChanged = "file_changed"
    case fileCommentAdded = "file_comment_added"
    case fileCommentDeleted = "file_comment_deleted"
    case fileCommentEdited = "file_comment_edited"
    case fileCreated = "file_created"
    case fileDeleted = "file_deleted"
    case filePublic = "file_public"
    case fileShared = "file_shared"
    case fileUnshared = "file_unshared"
    case gridMigrationFinished = "grid_migration_finished"
    case gridMigrationStarted = "grid_migration_started"
    case groupArchive = "group_archive"
    case groupClose = "group_close"
    case groupDeleted = "group_deleted"
    case groupHistoryChanged = "group_history_changed"
    case groupLeft = "group_left"
    case groupOpen = "group_opem"
    case groupRename = "group_rename"
    case groupUnarchive = "group_unarchive"
    case imClose = "im_close"
    case imCreated = "im_created"
    case imHistoryChanged = "im_history_changed"
    case imOpen = "im_open"
    case linkShared = "link_shared"
    case memberJoinedChannel = "memeber_joined_channel"
    case memeberLeftChannel = "memeber_left_channel"
    case message
    case pinAdded = "pin_added"
    case pinRemoved = "pin_removed"
    case reactionAdded = "reaction_added"
    case reactionRemoved = "reaction_removed"
    case resourcesAdded = "resources_added"
    case resourcesRemoved = "resources_removed"
    case scopeDenied = "scope_denied"
    case scopeGranted = "scope_granted"
    case starAdded = "star_added"
    case starRemoved = "star_removed"
    case subteamCreated = "subteam_created"
    case subteamMembersChanged = "subteam_memebers_changed"
    case subteamSelfAdded = "subteam_self_added"
    case subteamSelfRemoved = "subteam_self_removed"
    case subteamUpdated = "subteam_updated"
    case teamDomainChange = "team_domain_changed"
    case teamJoin = "team_join"
    case teamRename = "team_rename"
    case tokensRevoked = "tokens_revoked"
    case userChange = "user_change"
    case userResourceDenied = "user_resource_denied"
    case userResourceGranted = "user_resource_granted"
    case userResourceRemoved = "user_resource_removed"
}

public protocol Event: Decodable {

    var type: EventType { get set }
}
