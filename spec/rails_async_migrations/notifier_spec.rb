# frozen_string_literal: true
RSpec.describe(RailsAsyncMigrations::Notifier) do
  let(:slack_notifier) { ::Slack::Notifier.new('https://webhook.com') }

  before do
    allow(::Slack::Notifier).to(receive(:new).and_return(slack_notifier))
    allow(slack_notifier).to(receive(:post))
  end

  subject { described_class.new }

  [
    { method: 'processing', color: 'warning' },
    { method: 'failed', color: 'danger' },
    { method: 'done', color: 'good' },
  ].each do |v|
    describe "##{v[:method]}" do
      context 'when a slack_webhook_url is defined' do
        before do
          allow(RailsAsyncMigrations.config).to(receive(:slack_webhook_url).and_return(
            'https://webhook.com'
          ))
        end

        it 'post a message' do
          subject.send(v[:method], 'Nostrud magna')

          expect(slack_notifier).to(have_received(:post).with(attachments: [{
            text: 'Nostrud magna',
            color: v[:color],
          }]))
        end

        context 'when custom header message is provided' do
          before do
            allow(RailsAsyncMigrations.config).to(receive(:slack_title_message).and_return(
              'Hivebrite (test)'
            ))
          end

          it 'post a message with a header message' do
            subject.send(v[:method], 'Nostrud magna')

            expect(slack_notifier).to(have_received(:post).with(attachments: [{
              title: 'Hivebrite (test)',
              text: 'Nostrud magna',
              color: v[:color],
            }]))
          end
        end
      end

      context 'when verbose mode is enable' do
        it 'post a verbose message' do
          allow(RailsAsyncMigrations.config).to(receive(:mode).and_return(:verbose))

          expect { subject.send(v[:method], 'Nostrud magna') }.to(output("[VERBOSE] Nostrud magna\n").to_stdout)
        end
      end

      context 'otherwise' do
        it 'does nothing' do
          allow(RailsAsyncMigrations.config).to(receive(:mode))
          allow(RailsAsyncMigrations.config).to(receive(:slack_webhook_url))

          expect { subject.send(v[:method], 'Nostrud magna') }.not_to(output.to_stdout)

          expect(slack_notifier).not_to(have_received(:post))
        end
      end
    end
  end
end
