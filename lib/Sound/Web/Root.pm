package Sound::Web::Root;
use Mojo::Base 'Mojolicious::Controller';
use File::Temp;

# This action will render a template
sub upload {
  my $self = shift;
  my $audio = $self->req->upload('audio');
  my $tmp = File::Temp->new( TEMPLATE => 'audio_XXXXX',
                                   DIR => '/tmp',
                                   SUFFIX => '.wav');

  $audio->move_to($tmp->filename);

  warn($tmp->filename);
  warn($audio->size);

  # Render template "example/welcome.html.ep" with message
  $self->render(msg => 'Welcome to the Mojolicious real-time web framework!');
}

1;
