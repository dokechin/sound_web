package Sound::Web::Root;
use Mojo::Base 'Mojolicious::Controller';
use File::Temp();
use Audio::Analyzer::ToneDetect;
use Mojolicious::Validator;
use Mojolicious::Validator::Validation;


# This action will render a template
sub index {
  my $self = shift;

  $self->render();
}

# This action will render a template
sub upload {
  my $self = shift;

  my $validation = $self->validation;
  if ($validation->csrf_protect->has_error('csrf_token') ) {
     warn("csrf protect");
     die;
  }

  my $audio = $self->req->upload('audio');
  my $tmp = File::Temp->new( TEMPLATE => 'audio_XXXXX',
                                   DIR => '/tmp',
                                   SUFFIX => '.wav');
  close($tmp);

  $audio->move_to($tmp->filename);

  my $td = Audio::Analyzer::ToneDetect->new(
        source => $tmp->filename ,
        sample_rate => 22050);

  my $tone = $td->get_next_tone;

  warn($tone);

  # Render template "example/welcome.html.ep" with message
  $self->render(msg => $tone);
}

1;
