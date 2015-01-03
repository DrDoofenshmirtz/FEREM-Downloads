create table users (
  id         uuid primary key,
  e_mail     text not null,
  created_at timestamp not null default current_timestamp,
  unique(e_mail)
);

create index users_e_mail_idx on users(e_mail);

create table downloads (
  id            uuid primary key,
  user_id       uuid references users(id) on delete cascade not null,
  created_at    timestamp not null default current_timestamp,
  downloaded_at timestamp
);

create index downloads_created_at_idx on downloads(created_at);
create index downloads_downloaded_at_idx on downloads(downloaded_at);

