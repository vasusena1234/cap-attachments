namespace my.bookshop;

using {Attachments} from '@cap-js/attachments';

entity Books {
  key ID    : Integer;
      title : String;
      stock : Integer;
      Book  : Composition of many Attachments;
}
