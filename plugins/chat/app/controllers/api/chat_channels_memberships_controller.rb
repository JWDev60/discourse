# frozen_string_literal: true

class Chat::Api::ChatChannelsMembershipsController < Chat::Api::ChatChannelsController
  INDEX_LIMIT = 50

  def index
    params.permit(:username, :offset, :limit)

    offset = params[:offset].to_i
    limit = fetch_limit_from_params(default: INDEX_LIMIT, max: INDEX_LIMIT)

    memberships =
      ChatChannelMembershipsQuery.call(
        channel_from_params,
        offset: offset,
        limit: limit,
        username: params[:username],
      )

    render_serialized(
      memberships,
      UserChatChannelMembershipSerializer,
      root: "memberships",
      meta: {
        total_rows: channel_from_params.user_count,
        load_more_url:
          "/chat/api/channels/#{channel_from_params.id}/memberships?offset=#{offset + limit}&limit=#{limit}&username=#{params[:username]}",
      },
    )
  end
end
