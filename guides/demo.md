# In-Person Demo Script

    SET search_path TO public, message_store;

# Views

    select * from message_store.messages where type = 'VideoViewed' order by global_position;
    select * from pages;

# Registration

    select * from message_store.messages where type = 'Register' order by global_position;
    select * from message_store.messages where type = 'Registered' order by global_position;

    select * from user_credentials;

# Email - Background Job

    select * from message_store.messages where type = 'Send' order by global_position;
    select * from message_store.messages where type = 'Sent' order by global_position;
    select * from message_store.messages where type = 'RegistrationEmailSent' order by global_position;

    select * from get_stream_messages('identity-220eb76f-95d3-489a-9f24-5a10b2e6aee5');

# Video Publishing

    select * from message_store.messages where type = 'videoPublished' order by global_position;
    select * from creators_portal_video_operations;

# Admin

- users
- messages - message details, trace (Register)