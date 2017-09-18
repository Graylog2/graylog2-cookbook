require 'spec_helper'

describe command('timeout 60 bash -c "until curl -s -H \'Accept: application/json\' -u F3DenL9HXW12KECdLmrfQ8HNGW4zwbwlJSyo7PxlsgHvgeay5F3tQhnoH6T2G7X3iiy2bcYPClsjCWi1PIY48sCSSyoW4H64:token http://127.0.0.1:9000/api/dashboards; do sleep 1; done"') do
  its(:stdout) { should contain 'dashboards' }
end
