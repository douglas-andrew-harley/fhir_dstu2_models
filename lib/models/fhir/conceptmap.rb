# Copyright (c) 2011-2015, HL7, Inc & The MITRE Corporation
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without modification, 
# are permitted provided that the following conditions are met:
# 
#     * Redistributions of source code must retain the above copyright notice, this 
#       list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright notice, 
#       this list of conditions and the following disclaimer in the documentation 
#       and/or other materials provided with the distribution.
#     * Neither the name of HL7 nor the names of its contributors may be used to 
#       endorse or promote products derived from this software without specific 
#       prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT 
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.

module FHIR
    class ConceptMap 
        
        include Mongoid::Document
        include Mongoid::History::Trackable
        include FHIR::Element
        include FHIR::Resource
        include FHIR::Formats::Utilities
        include FHIR::Serializer::Utilities
        extend FHIR::Deserializer::ConceptMap
        
        SEARCH_PARAMS = [
            'date',
            'identifier',
            'product',
            'dependson',
            'description',
            'targetsystem',
            'source',
            'version',
            'sourcesystem',
            'url',
            'target',
            'sourcecode',
            'sourceuri',
            'name',
            'context',
            'publisher',
            'targetcode',
            'status'
        ]
        
        VALID_CODES = {
            useContext: [ 'AK', 'AL', 'AR', 'AS', 'AZ', 'CA', 'CO', 'CT', 'DC', 'DE', 'FL', 'FM', 'GA', 'GU', 'HI', 'IA', 'ID', 'IL', 'IN', 'KS', 'KY', 'LA', 'MA', 'MD', 'ME', 'MH', 'MI', 'MN', 'MO', 'MP', 'MS', 'MT', 'NC', 'ND', 'NE', 'NH', 'NJ', 'NM', 'NV', 'NY', 'OH', 'OK', 'OR', 'PA', 'PR', 'PW', 'RI', 'SC', 'SD', 'TN', 'TX', 'UM', 'UT', 'VA', 'VI', 'VT', 'WA', 'WI', 'WV', 'WY', 'cardio', 'dent', 'dietary', 'midw', 'sysarch' ],
            status: [ 'draft', 'active', 'retired' ]
        }
        
        MULTIPLE_TYPES = {
            source: [ 'sourceUri', 'sourceReference' ],
            target: [ 'targetUri', 'targetReference' ]
        }
        
        # This is an ugly hack to deal with embedded structures in the spec contact
        class ConceptMapContactComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            field :name, type: String
            embeds_many :telecom, class_name:'FHIR::ContactPoint'
        end
        
        # This is an ugly hack to deal with embedded structures in the spec dependsOn
        class OtherElementComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            field :element, type: String
            validates_presence_of :element
            field :codeSystem, type: String
            validates_presence_of :codeSystem
            field :code, type: String
            validates_presence_of :code
        end
        
        # This is an ugly hack to deal with embedded structures in the spec target
        class TargetElementComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            
            VALID_CODES = {
                equivalence: [ 'equivalent', 'equal', 'wider', 'subsumes', 'narrower', 'specializes', 'inexact', 'unmatched', 'disjoint' ]
            }
            
            field :codeSystem, type: String
            field :code, type: String
            field :equivalence, type: String
            validates :equivalence, :inclusion => { in: VALID_CODES[:equivalence] }
            validates_presence_of :equivalence
            field :comments, type: String
            embeds_many :dependsOn, class_name:'FHIR::ConceptMap::OtherElementComponent'
            embeds_many :product, class_name:'FHIR::ConceptMap::OtherElementComponent'
        end
        
        # This is an ugly hack to deal with embedded structures in the spec element
        class SourceElementComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            field :codeSystem, type: String
            field :code, type: String
            embeds_many :target, class_name:'FHIR::ConceptMap::TargetElementComponent'
        end
        
        field :url, type: String
        embeds_one :identifier, class_name:'FHIR::Identifier'
        field :versionNum, type: String
        field :name, type: String
        field :status, type: String
        validates :status, :inclusion => { in: VALID_CODES[:status] }
        validates_presence_of :status
        field :experimental, type: Boolean
        field :publisher, type: String
        embeds_many :contact, class_name:'FHIR::ConceptMap::ConceptMapContactComponent'
        field :date, type: String
        validates :date, :allow_nil => true, :format => {  with: /\A[0-9]{4}(-(0[1-9]|1[0-2])(-(0[0-9]|[1-2][0-9]|3[0-1])(T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\.[0-9]+)?(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?)?)?)?\Z/ }
        field :description, type: String
        embeds_many :useContext, class_name:'FHIR::CodeableConcept'
        field :requirements, type: String
        field :copyright, type: String
        field :sourceUri, type: String
        validates_presence_of :sourceUri
        embeds_one :sourceReference, class_name:'FHIR::Reference'
        validates_presence_of :sourceReference
        field :targetUri, type: String
        validates_presence_of :targetUri
        embeds_one :targetReference, class_name:'FHIR::Reference'
        validates_presence_of :targetReference
        embeds_many :element, class_name:'FHIR::ConceptMap::SourceElementComponent'
        track_history
    end
end
