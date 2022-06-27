# frozen_string_literal: true

require 'rails_helper'

describe '投稿のテスト' do
  let! (:list) { create(:list, title: 'hoge', body: 'fuga') }
  describe 'トップ画面(top_path)のテスト' do
    before 'トップ画面への遷移' do
      visit top_path
    end
    context '表示の確認' do
      it 'トップ画面(top_path)に「ここはTopページです」が表示されているか' do
        expect(page).to have_content 'ここはTopページです'
      end
      it 'top_pathが/topであるか' do
        expect(current_path).to eq('/top')
      end
    end
  end
  describe '投稿画面のテスト' do
    before '投稿画面への遷移' do
      visit new_list_path
    end
    context '表示の確認' do
      it 'new_list_pathが"/list/newであるか"' do
        expect(current_path).to eq('/lists/new')
      end
      it '投稿ボタンが表示されているか' do
        expect(page).to have_button '投稿'
      end
    end
    context '投稿処理のテスト' do
      it '投稿後のリダイレクト先は正しいか' do
        fill_in 'list[title]', with: Faker::Lorem.characters(number:5)
        fill_in 'list[body]', with: Faker::Lorem.characters(number:10)
        click_button '投稿'
        expect(page).to have_current_path list_path(List.last)
      end
    end
  end
  describe '一覧画面のテスト' do
    before '一覧画面への遷移' do
      visit lists_path
    end
    context '一覧の表示とリンクの確認' do
      it '一覧表示画面に投稿されたものが表示されているか' do
        expect(page).to have_content list.body
        expect(page).to have_content list.title
        expect(page).to have_link list.title
        lists_link = find_all('a')[3]
        expect(lists_link[:href]).to eq list_path(list)
      end
    end
  end
  describe '詳細画面のテスト' do
    before '詳細画面への遷移' do
      visit list_path(list)
    end
    context '表示のテスト' do
      it '削除リンクが存在しているか' do
        # destroy_link = find_all('a')[4]
        # expect(destroy_link).to have_content '削除'
        expect(page).to have_link '削除'
      end
      it '編集リンクが存在しているか' do
        # edit_link = find_all('a')[3]
        # expect(edit_link).to have_content '編集'
        expect(page).to have_link '編集'
      end
    end
    context 'リンクの遷移先の確認' do
      it '編集の遷移先は編集画面か' do
        edit_link = find_all('a')[3]
        edit_link.click
        expect(current_path).to eq('/lists/' + list.id.to_s + '/edit')
      end
    end
    context 'list削除のテスト' do
      it 'listの削除' do
        expect{ list.destroy }.to change{ List.count }.by(-1)
      end
    end
  end
  describe '編集画面のテスト' do
    before '編集画面への遷移' do
      visit edit_list_path(list)
    end
    context '表示の確認' do
      it '編集前のタイトルと本文がフォームに表示(セット)されている' do
        expect(page).to have_field 'list[title]', with: list.title
        expect(page).to have_field 'list[body]', with: list.body
      end
      it '保存ボタンが表示されている' do
        expect(page).to have_button '保存'
      end
    end
    context '更新処理に関するテスト' do
      it '更新後のリダイレクト先は正しいか' do
        fill_in 'list[title]', with: list.title
        fill_in 'list[body]', with: list.body
        click_button '保存'
        expect(page).to have_current_path list_path(list)
      end
    end
  end
end
