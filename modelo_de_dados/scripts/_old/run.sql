--connect masterqosala@(QOALA)
spool run.log
--@1_create_user_administrator.sql
@2_create_tables.sql
@3_create_sequences.sql
@4_create_package_comments.sql
@5_create_package_posts.sql
@6_create_package_users.sql
@7_create_package_devices.sql
@8_create_package_device_geo_locations.sql
spool off